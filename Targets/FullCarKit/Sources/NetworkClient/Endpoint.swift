//
//  Endpoint.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

public struct Endpoint { }
public extension Endpoint {
    enum Car {
        case fetch(carNo: String, carName: String, carBrand: String, carColor: String)
    }
    
    enum CarPull {
        case fetch(page: Int, size: Int)
        case register(
            pickupLocation: String,
            periodType: String,
            money: Int,
            content: String,
            moodType: String?
        )
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

extension Endpoint.Car: URLRequestConfigurable {
    public var url: URLConvertible {
        switch self {
        case .fetch: return "http://43.200.176.240:8080"
        }
    }
    
    public var path: String? {
        switch self {
        case .fetch: return "/api/v1/cars"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetch: return .post
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .fetch(let carNo, let carName, let carBrand, let carColor): return [
            "carNo": "\(carNo)",
            "carName": "\(carName)",
            "carBrand": "\(carBrand)",
            "carColor": "\(carColor)",
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
        case .fetch: return JSONEncoding()
        }
    }
}

extension Endpoint.CarPull: URLRequestConfigurable {
    public var url: URLConvertible {
        switch self {
        case .fetch, .register: return "http://43.200.176.240:8080"
        }
    }
    
    public var path: String? {
        switch self {
        case .fetch, .register: return "/api/v1/carpools"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetch: return .get
        case .register: return .post
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .fetch(let page, let size): return [
            "page": "\(page)",
            "size": "\(size)"
        ]
        case let .register(
            pickupLocation,
            periodType,
            money,
            content,
            moodType
        ): 
            var param: [String: Any] = [
                "pickupLocation": pickupLocation,
                "periodType": periodType,    
                "money": money,
                "content": content,
            ]
            if let moodType {
                param["moodType"] = moodType
                return param
            } else {
                return param
            }
        }
    }
    
    public var headers: [Header]? {
        switch self {
        case .fetch, .register: return nil
        }
    }
    
    public var encoder: ParameterEncodable {
        switch self {
        case .fetch: return URLEncoding()
        case .register: return JSONEncoding()
        }
    }
}
