//
//  NetworkError.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

@frozen public enum NetworkError: Error {
    case invalidURL(URLConvertible)
    case endpointCongifureFailed
    case parameterEnocdingFailed(ParameterEncoding)
    case invalidResponse(Response)
    case invalidSession(Session)
}

extension NetworkError {
    public enum ParameterEncoding: Error {
        case missingURL
        case invalidJSON
        case jsonEncodingFailed
    }
}

extension NetworkError {
    public enum Decoding: Error {
        case failed
        case dataIsNil
    }
}

extension NetworkError {
    public enum Response: Error {
        case cancelled
        case unhandled(error: Error?)
        case invalidStatusCode(code: Int)
        
        init(statusCode: Int, error: Error?) {
            if statusCode == 500 {
                self = .invalidStatusCode(code: statusCode)
            } else {
                self = .unhandled(error: error)
            }
        }
    }
}

extension NetworkError {
    /// 현재는 사용할 일 x
    public enum Session: Error {
        case invalidSession
        case invalidToken
        case updateRequired
    }
}

extension NetworkError {
    static func isNetworkError(_ error: Error) -> Bool {
        return (error as NSError).domain == "NSURLErrorDomain"
    }
}
