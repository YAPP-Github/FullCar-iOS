//
//  HeaderInterceptor.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

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
        return (urlRequest, .doNotRetry(with: error))
    }
}

extension TokenInterceptor {
    private func addToken(to urlRequest: URLRequest, for options: NetworkRequestOptions) async throws -> URLRequest {
//        @Dependency(\.togetherAccount) var togetherAccount 
//        var urlRequest = urlRequest
//        let credential = try await togetherAccount.token()
//        urlRequest.setHeader(.authorization("Bearer \(credential.xAuth)"))
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
