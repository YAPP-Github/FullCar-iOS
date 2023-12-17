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
    var login: (_ accessToken: String) -> Result<String, Error>
    var logout: () -> Void
    var leave: () -> Void
}

extension AccountAPI: DependencyKey {
    static var liveValue: AccountAPI {
        return  AccountAPI(
            login: { accessToken in
                // 추후 네트워크 통신 부분
                let response = Result<String, Error>.success("account token 발급 완료")
                return response
            },
            logout: { },
            leave: { }
        )
    }
}

extension DependencyValues {
    var accountAPI: AccountAPI {
        get { self[AccountAPI.self] }
        set { self[AccountAPI.self] = newValue }
    }
}
