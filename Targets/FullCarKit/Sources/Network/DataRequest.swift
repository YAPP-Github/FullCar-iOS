//
//  DataRequest.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public final class DataRequest: NetworkRequestable {
    public let session: URLSession
    public let task: URLSessionTask?
    public let endpoint: URLRequestConfigurable
    public let options: NetworkRequestOptions
    public let interceptors: [NetworkInterceptor]

    public init(
        session: URLSession,
        task: URLSessionTask? = nil,
        endpoint: URLRequestConfigurable,
        options: NetworkRequestOptions = .all,
        interceptors: [NetworkInterceptor]
    ) {
        self.session = session
        self.task = task
        self.endpoint = endpoint
        self.options = options
        self.interceptors = interceptors
    }
    
    @MainActor
    public func response<Model: Decodable>(with decoder: JSONDecoder = .init()) async throws -> Model {
        let response = try await fetchResponse()
        try self.validate(response: response)
        let result: Model = try self.decode(with: decoder, response: response)

        #if DEBUG
        print(
                """

                [ℹ️] NETWORK -> response status code:
                    \(result)

                """
        )
        #endif

        return result
    }

    @MainActor
    public func response() async throws {
        let response = try await fetchResponse()
        try self.validate(response: response)
    }

    private func fetchResponse() async throws -> NetworkResponse {
        let initialRequest = try endpoint.asURLRequest()
        let urlRequest = try await adapt(request: initialRequest)
        let response = try await dataTask(with: urlRequest)

        #if DEBUG
        print(
        """
        [ℹ️] NETWORK -> response: 
            \(response.response)
        """
        )
        #endif

        return response
    }
    
    private func dataTask(with urlRequest: URLRequest) async throws -> NetworkResponse {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            return NetworkResponse(data: data, response: response, error: nil)
        }
        catch {
            return NetworkResponse(data: nil, response: nil, error: error)
        }
    }
}
