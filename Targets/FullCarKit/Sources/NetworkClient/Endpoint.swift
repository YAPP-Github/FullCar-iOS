//
//  Endpoint.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

public struct Endpoint { }
public extension Endpoint {
    enum Home {
        case fetch(id: String, name: String)
    }

    enum Account {
        case login(accessToken: String)
    }
}

extension Endpoint.Account: URLRequestConfigurable {
    public var url: URLConvertible {
        switch self {
        case .login(let accessToken): return "https://www.test.com"
        }
    }
    
    public var path: String? {
        switch self {
        case .login: return "/login"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .login: return .post
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .login(let accessToken): return [
            "accessToken": "\(accessToken)"
        ]
        }
    }
    
    public var headers: [Header]? {
        switch self {
        case .login: return nil
        }
    }
    
    public var encoder: ParameterEncodable {
        switch self {
        case .login: return JSONEncoding()
        }
    }
}

extension Endpoint.Home: URLRequestConfigurable {
    public var url: URLConvertible {
        switch self {
        case .fetch: return "https://www.naver.com"
        }
    }
    
    public var path: String? {
        switch self {
        case .fetch: return ""
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetch: return .get
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .fetch(let id, let name): return [
            "id": "\(id)",
            "name": "\(name)"
        ]
        }
    }
    
    public var headers: [Header]? {
        switch self {
        case .fetch: return nil
        }
    }
    
    public var encoder: ParameterEncodable {
        switch self {
        case .fetch: return URLEncoding()
        }
    }
}
