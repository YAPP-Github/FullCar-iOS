//
//  URLRequestConfigurable.swift
//  FullCarKit
//
//  Created by 한상진 on 12/18/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public protocol URLRequestConfigurable {
    var url: URLConvertible { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: [Header]? { get }
    var encoder: ParameterEncodable { get }
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConfigurable {
    public func asURLRequest() throws -> URLRequest {
        let url = try url.asURL()
        var request =  URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.dictionary
        return try encoder.encode(request: request, with: parameters)
    }
}
