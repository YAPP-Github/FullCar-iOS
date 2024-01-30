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
        case login(request: AuthRequest)
        case logout
        case leave
        case refresh(refreshToken: String)
    }
}

extension Endpoint.Account: URLRequestConfigurable {
    public var url: URLConvertible { return "http://43.200.176.240:8080" }

    public var path: String? {
        switch self {
        case .login: return "/api/v1/auth"
        case .logout: return "/logout"
        case .leave: return "/leave"
        case .refresh: return "/api/v1/auth/token"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .logout: return .post
        case .leave: return .post
        case .refresh: return .post
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .login(let request): return [
            "socialType": request.socialType.rawValue,
            "token": request.token,
            "deviceToken": request.deviceToken
        ]
        case .logout: return nil
        case .leave: return nil
        case .refresh(refreshToken: let refreshToken): return [
            "refreshToken": "\(refreshToken)"
        ]
        }
    }
    
    public var headers: [Header]? {
        switch self {
        case .login: return nil
        case .logout: return nil
        case .leave: return nil
        case .refresh: return nil
        }
    }
    
    public var encoder: ParameterEncodable {
        switch self {
        case .login: return JSONEncoding()
        case .logout: return URLEncoding()
        case .leave: return URLEncoding()
        case .refresh: return JSONEncoding()
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
        case .fetch: return nil
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
