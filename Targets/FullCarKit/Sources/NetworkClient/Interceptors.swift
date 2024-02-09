//
//  HeaderInterceptor.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation
import Dependencies

struct ErrorInterceptor: NetworkInterceptor {
    func adapt(urlRequest: URLRequest, options: NetworkRequestOptions) async throws -> URLRequest {
        return urlRequest
    }
    
    func retry(
        urlRequest: URLRequest, 
        response: URLResponse?, 
        data: Data?, 
        with error: Error, 
        options: NetworkRequestOptions
    ) async -> (URLRequest, RetryResult) {
        let mappedError = map(error: error, response: response, data: data)
        // sessionError일 경우 kickout 해야하지만 현재 미구현
        return (urlRequest, .doNotRetry(with: mappedError))
    }
}

extension ErrorInterceptor {
    private func map(error: Error, response: URLResponse?, data: Data?) -> Error {
        if (error as NSError).code == NSURLErrorCancelled { return NetworkError.Response.cancelled }
        if let networkError = error as? NetworkError { return networkError }
        guard let httpResponse = response as? HTTPURLResponse else { return NetworkError.Response.unhandled(error: error) }
        let statusCode = httpResponse.statusCode
        // if let sessionError = SessionError(statusCode, error)
        return NetworkError.Response(statusCode: statusCode, error: error)
    }
}

struct TokenInterceptor: NetworkInterceptor {
    func adapt(urlRequest: URLRequest, options: NetworkRequestOptions) async throws -> URLRequest {
        let request = try await addToken(to: urlRequest, for: options)
        return request
    }
    
    func retry(
        urlRequest: URLRequest, 
        response: URLResponse?, 
        data: Data?, 
        with error: Error, 
        options: NetworkRequestOptions
    ) async -> (URLRequest, RetryResult) {
        // access token 만료인 401 에러일 때만 실행
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.isUnAuthorizedStatus() else {
            return (urlRequest, .doNotRetry(with: error))
        }

        do {
            // access token 재발급
            try await refresh()
            return (urlRequest, .retry)
        } catch {
            return (urlRequest, .doNotRetry(with: error))
        }
    }

    private func refresh() async throws {
        @Dependency(\.tokenStorage) var tokenStorage

        let credential = try await tokenStorage.loadToken()
        let authResponse: ApiAuthTokenResponse = try await NetworkClient.account.request(
            endpoint: Endpoint.Account.refresh(refreshToken: credential.refreshToken)
        ).response()
        let newCredential: AccountCredential = .init(
            accessToken: authResponse.data.accessToken,
            refreshToken: authResponse.data.refreshToken
        )
        await tokenStorage.save(token: newCredential)
    }
}

extension TokenInterceptor {
    private func addToken(to urlRequest: URLRequest, for options: NetworkRequestOptions) async throws -> URLRequest {
        @Dependency(\.tokenStorage) var tokenStorage

        var urlRequest = urlRequest
        let credential = try await tokenStorage.loadToken()

        urlRequest.setHeaders([.authorization("Bearer \(credential.accessToken)")])
        return urlRequest
    }
}


struct HeaderInterceptor: NetworkInterceptor {
    func adapt(urlRequest: URLRequest, options: NetworkRequestOptions) async throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setHeaders(Self.headers)
        return urlRequest
    }
    
    func retry(
        urlRequest: URLRequest, 
        response: URLResponse?, 
        data: Data?, 
        with error: Error, 
        options: NetworkRequestOptions
    ) async -> (URLRequest, RetryResult) {
        return (urlRequest, .doNotRetry(with: error))
    }
}

extension HeaderInterceptor {
    static var headers: [Header] = {
        var headers: [Header] = .init()
        headers.append(.contentType(value: "application/json"))
        return headers
    }()
}

extension HTTPURLResponse {
    fileprivate func isUnAuthorizedStatus() -> Bool {
        return 401 == statusCode
    }
}
