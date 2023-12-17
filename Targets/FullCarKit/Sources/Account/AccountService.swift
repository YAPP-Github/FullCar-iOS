//
//  AccountService.swift
//  FullCarKit
//
//  Created by Sunny on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation
import Dependencies

public struct AccountService {
    public var hasValidToken: () -> Bool
    public var login: (_ accessToken: String) throws -> Void
    public var logout: () -> Void
    public var leave: () -> Void
}

extension AccountService: DependencyKey {
    public static var liveValue: AccountService {
        @Dependency(\.accountAPI) var api
        @Dependency(\.tokenStorage) var tokenStorage

        return AccountService(
            hasValidToken: {
                guard let credential = tokenStorage.loadToken() else { return false }
                return credential.authTokenExpiration > Date()
            },
            login: { accessToken in
                let response = api.login(accessToken)

                switch response {
                case .success(let token):
                    // 서버에서 받아온 account token과 유효기간 저장
                    let credential = AccountCredential(
                        authToken: token,
                        authTokenExpiration: Date()
                    )
                    tokenStorage.save(token: credential)
                case .failure(let error):
                    throw error
                }
            },
            logout: {
                api.logout()
            },
            leave: {
                api.leave()
                tokenStorage.deleteToken()
            }
        )
    }
}

extension DependencyValues {
    public var accountService: AccountService {
        get { self[AccountService.self] }
        set { self[AccountService.self] = newValue }
    }
}
