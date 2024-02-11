//
//  App.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import Foundation
import Dependencies

@Observable
public final class FullCar {
    public static let shared: FullCar = .init()
    private init() { }
    
    public var appState: FullCar.State = .root
    public var member: MemberInformation? {
        switch self.appState {
        case .root, .login, .onboarding:
            return nil
        case .tab(let memberInformation):
            return memberInformation
        }
    }
}

extension FullCar: DependencyKey {
    public static var liveValue: FullCar = .shared
}
extension DependencyValues {
    public var fullCar: FullCar {
        get { self[FullCar.self] }
        set { self[FullCar.self] = newValue }
    }
}

public extension FullCar {
    enum State {
        case root
        case login
        case onboarding
        case tab(MemberInformation)
    }
} 

public extension FullCar {
    enum Tab: String, Hashable {
        case home
        case request
        case register
        case settings
        case experiment
    }
    
    enum CallListTab: String, Hashable {
        case request
        case receive
    }
    
    enum CallPullOpenState: String, Hashable {
        case OPEN = "OPEN"
        case CLOSE = "CLOSE"
    }
    
    enum CallStatus: String, Hashable {
        case REQUEST = "요청중"
        case ACCEPT = "매칭 성공"
        case REJECT = "매칭 취소"
        
        public static func replace(_ value: String) -> CallStatus {
            switch value {
            case "REQUEST":
                return .REQUEST
            case "ACCEPT":
                return .ACCEPT
            case "REJECT":
                return .REJECT
            default:
                return .ACCEPT
            }
        }
    }
}
