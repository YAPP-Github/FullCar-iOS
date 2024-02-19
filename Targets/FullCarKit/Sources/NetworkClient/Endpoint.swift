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
        enum Login {
            case kakao(KakaoAuthRequest)
            case apple(AppleAuthRequest)
        }
        case logout
        case leave
        case refresh(refreshToken: String)
        case register(deviceToken: String)
    }
    
    enum Form {
        case fetchSentForms
        case fetchReceivedForms
        case getFormDetail(formId: Double)
        case changeFormStatus(formId: Double, formState: String, contact: String, toPassenger: String?)
        case applyCarpull(formId: Double, pickupLocation: String, periodType: String, money: Int, content: String)
    }

    enum Member {
        case search(location: String, key: String)
        case check(nickname: String)
        case register(member: MemberInformation)
        case send(email: String)
        case verify(code: String)
        case fetch
    }
}

extension Endpoint.Account: URLRequestConfigurable {
    public var url: URLConvertible { return "http://43.200.176.240:8080" }

    public var path: String? {
        switch self {
        case .logout: return "/api/v1/auth/logout"
        case .leave: return "/api/v1/auth"
        case .refresh: return "/api/v1/auth/token"
        case .register: return "/api/v1/members/device-token"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .logout, .refresh, .register : return .post
        case .leave: return .delete
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .refresh(refreshToken: let refreshToken): return [
            "refreshToken": refreshToken
        ]
        case .register(deviceToken: let deviceToken): return [
            "deviceToken": deviceToken
        ]
        default: return nil
        }
    }
    
    public var headers: [Header]? {
        switch self {
        default : return nil
        }
    }
    
    public var encoder: ParameterEncodable {
        switch self {
        case .refresh, .register: return JSONEncoding()
        case .logout, .leave: return URLEncoding()
        }
    }
}

extension Endpoint.Account.Login: URLRequestConfigurable {
    var url: URLConvertible { return "http://43.200.176.240:8080" }

    var path: String? {
        switch self {
        case .kakao: return "/api/v1/auth/login/kakao"
        case .apple: return "/api/v1/auth/login/apple"
        }
    }
    
    var method: HTTPMethod { return .post }

    var parameters: Parameters? {
        switch self {
        case .kakao(let request): [
            "token": request.token
        ]
        case .apple(let request): [
            "authCode": request.authCode,
            "idToken": request.idToken
        ]
        }
    }
    
    var headers: [Header]? { return nil }

    var encoder: ParameterEncodable { return JSONEncoding() }
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

extension Endpoint.Member: URLRequestConfigurable {
    public var url: URLConvertible {
        switch self {
        case .search: return "https://dapi.kakao.com"
        case .check, .register, .send, .fetch, .verify : return "http://43.200.176.240:8080"
        }
    }
    
    public var path: String? {
        switch self {
        case .search: return "/v2/local/search/keyword.json"
        case .check: return "/api/v1/members/onboarding/nickname"
        case .register: return "/api/v1/members/onboarding"
        case .send: return "/api/v1/members/onboarding/company/email"
        case .fetch: return "/api/v1/members"
        case .verify: return "/api/v1/members/onboarding/company/email/check"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .search, .fetch: return .get
        case .check, .register, .send, .verify: return .post
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .search(let location, _): return [
            "query": location
        ]
        case .check(let nickname): return [
            "nickname": nickname
        ]
        case .register(let member): return [
            "companyName": member.company.name,
            "latitude": member.company.latitude,
            "longitude": member.company.longitude,
            "email": member.email,
            "nickname": member.nickname,
            "gender": member.gender
        ]
        case .send(let email): return [
            "email": email
        ]
        case .verify(let code): return [
            "code": code
        ]
        default: return nil
        }
    }
    
    public var headers: [Header]? {
        switch self {
        case .search(_, let key): return [
            .authorization("KakaoAK \(key)")
        ]
        default: return nil
        }
    }
    
    public var encoder: ParameterEncodable {
        switch self {
        case .search, .fetch: return URLEncoding()
        case .check, .register, .send, .verify: return JSONEncoding()
        }
    }
}
    
extension Endpoint.Form: URLRequestConfigurable {
    public var url: URLConvertible {
        switch self {
        default: return "http://43.200.176.240:8080"
        }
    }
    
    public var path: String? {
        switch self {
        case .fetchSentForms: return "api/v1/sent-forms"
        case .fetchReceivedForms: return "api/v1/received-forms"
        case .getFormDetail(let id): return "api/v1/forms/\(id)"
        case .changeFormStatus(let id,_,_,_): return "api/v1/forms/\(id)"
        case .applyCarpull(let id,_,_,_,_): return "api/v1/carpools/\(id)/forms"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchSentForms, .fetchReceivedForms, .getFormDetail: return .get
        case .changeFormStatus: return .patch
        case .applyCarpull: return .post
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .fetchReceivedForms, .fetchSentForms, .getFormDetail: return nil
        case .changeFormStatus(_, let formState, let contact, let toPassenger):
            
            var parameter: Parameters = [
                "formState": formState,
                "contact": contact
            ]
            
            if let toPassenger {
                parameter["toPassenger"] = toPassenger
            }
            
            return parameter
        case .applyCarpull(_, let pickupLocation, let periodType, let money, let content):
            return [
                  "pickupLocation": pickupLocation,
                  "periodType": periodType,
                  "money": money,
                  "content": content
            ]
        }
    }
    
    public var headers: [Header]? {
        switch self {
        case .fetchReceivedForms, .fetchSentForms, .getFormDetail, .changeFormStatus, .applyCarpull: return nil
        }
    }
    
    public var encoder: ParameterEncodable {
        switch self {
        case .fetchReceivedForms, .fetchSentForms, .getFormDetail: return URLEncoding()
        case .changeFormStatus, .applyCarpull: return JSONEncoding()
        }
    }
}
