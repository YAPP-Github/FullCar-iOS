//
//  AccountAPI.swift
//  FullCarKit
//
//  Created by Sunny on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation
import Dependencies

struct AccountAPI {
    func login(accessToken: String) -> Result<String, Error> {
        // 네트워크 통신
        let response = Result<String, Error>.success("account token 발급 완료")
        return response
    }

    func logout() { }

    func leave() { }
}

extension DependencyValues {
    var accountAPI: AccountAPI {
        get { self[AccountAPI.self] }
        set { self[AccountAPI.self] = newValue }
    }
}

extension AccountAPI: DependencyKey {
    static let liveValue: AccountAPI = .init()
}
