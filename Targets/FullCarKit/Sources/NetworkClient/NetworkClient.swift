//
//  NetworkClient.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public struct NetworkClient {
    private let session: URLSession
    private var interceptors: [NetworkInterceptor]
    
    public init(
        session: URLSession = .main,
        interceptors: [NetworkInterceptor] = []
    ) {
        self.session = session
        self.interceptors = interceptors
    }
    
    public func request(
        endpoint: URLRequestConfigurable,
        interceptor: NetworkInterceptor? = nil
    ) -> DataRequest {
        var interceptors = self.interceptors
        
        if let interceptor {
            interceptors.append(interceptor)
        }
        
        return DataRequest(
            session: session,
            endpoint: endpoint,
            interceptors: interceptors.reversed()
        )
    }
}

public extension URLSession {
    static let main: URLSession = .init(configuration: .default)
}

public extension NetworkClient {
    static let headerInterceptor: NetworkInterceptor = HeaderInterceptor()
    static let tokenInterceptor: NetworkInterceptor = TokenInterceptor()
    static let errorInterceptor: NetworkInterceptor = ErrorInterceptor()

    static let main: NetworkClient = .init(session: .main, interceptors: [headerInterceptor, tokenInterceptor, errorInterceptor])
    static let account: NetworkClient = .init(session: .main, interceptors: [headerInterceptor, errorInterceptor])
}
