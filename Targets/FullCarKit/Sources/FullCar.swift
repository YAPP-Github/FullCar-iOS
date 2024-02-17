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
    public static let liveValue: FullCar = .shared
    public static let previewValue: FullCar = {
        let fc = FullCar()
        fc.appState = .tab(
            .init(
                company: .init(name: "카카오페이카카오페이카카오페이"), 
                email: "www.fullcar.com", 
                nickName: "테스트", 
                gender: "MALE"
            )
        )
        return fc
    }()
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
        case register
        case requestList
        case myPage
    }
    
    enum CallListTab: String, Hashable {
        case request
        case receive
    }
    
    enum CallStatus: String, Hashable {
        case waiting = "요청중"
        case success = "매칭 성공"
        case failure = "매칭 취소"
    }
}
