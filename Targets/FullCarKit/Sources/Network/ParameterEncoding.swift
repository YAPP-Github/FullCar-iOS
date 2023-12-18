//
//  ParameterEncoding.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

public protocol ParameterEncodable {
    func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest
}

public struct URLEncoding: ParameterEncodable {
    public func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var request = request
        guard let parameters else { return request }
        guard let url = request.url else {
            throw NetworkError.parameterEnocdingFailed(.missingURL)
        }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = parameters.compactMap { key, value in
                return URLQueryItem(name: key, value: "\(value)")
            }
            request.url = urlComponents.url 
        }
        return request
    }
}

public struct JSONEncoding: ParameterEncodable {
    public func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var request = request
        guard let parameters else { return request }
        guard JSONSerialization.isValidJSONObject(parameters) else {
            throw NetworkError.parameterEnocdingFailed(.invalidJSON)
        }
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = data
        }
        catch {
            throw NetworkError.parameterEnocdingFailed(.jsonEncodingFailed)
        }
        return request
    }
}
