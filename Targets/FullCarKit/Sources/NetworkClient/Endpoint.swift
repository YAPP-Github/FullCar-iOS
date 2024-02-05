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
        case logout
        case leave
        case refresh(refreshToken: String)
    }

    enum Member {
        case locationSearch(_ location: String, key: String)
    }
}

extension Endpoint.Account: URLRequestConfigurable {
    public var url: URLConvertible {
        switch self {
        case .login: return "https://www.test.com"
        case .logout: return "https://www.test.com"
        case .leave: return "https://www.test.com"
        case .refresh: return "https://www.test.com"
        }
    }
    
    public var path: String? {
        switch self {
        case .login: return "/login"
        case .logout: return "/logout"
        case .leave: return "/leave"
        case .refresh: return "/refresh"
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
        case .login(let accessToken): return [
            "accessToken": "\(accessToken)"
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

extension Endpoint.Member: URLRequestConfigurable {
    public var url: URLConvertible {
        switch self {
        case .locationSearch: return "https://dapi.kakao.com"
        }
    }
    
    public var path: String? {
        switch self {
        case .locationSearch: return "/v2/local/search/keyword.json"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .locationSearch: return .get
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .locationSearch(let location, _): return [
            "query": "\(location)"
        ]
        }
    }
    
    public var headers: [Header]? {
        switch self {
        case .locationSearch(_, let key): return [
            .authorization("KakaoAK \(key)")
        ]
        }
    }
    
    public var encoder: ParameterEncodable {
        switch self {
        case .locationSearch: return JSONEncoding()
        }
    }
}
