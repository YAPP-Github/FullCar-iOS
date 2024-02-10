//
//  App.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import Foundation

@Observable
public final class FullCar {
    public static let shared: FullCar = .init()
    private init() { }
    
    public var appState: FullCar.State = .root
}

public extension FullCar {
    enum State {
        case root
        case login 
        case tab
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
    
    enum CallStatus: String, Hashable {
        case waiting = "요청중"
        case success = "매칭 성공"
        case failure = "매칭 취소"
    }
}
