//
//  URLConvertible.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

public protocol URLConvertible {
    func asURL() throws -> URL
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw NetworkError.invalidURL(self) }
        return url
    } 
}

extension URL: URLConvertible {
    public func asURL() throws -> URL { return self }
}

public struct DataRequestConvertor: URLRequestConvertible {
    let url: URLConvertible
    let method: HTTPMethod
    let parameters: Parameters?
    let encoding: ParameterEncodable
    let headers: [Header]?
    
    public func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: url.asURL())
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.dictionary
        
        return try encoding.encode(request: request, with: parameters)
    }
}
