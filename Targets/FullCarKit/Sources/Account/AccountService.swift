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
    public var hasValidToken: () async throws -> Bool
    public var login: (_ accessToken: String) async throws -> Void
    public var logout: () async throws -> Void
    public var leave: () async throws -> Void
}

extension AccountService: DependencyKey {
    public static var liveValue: AccountService {
        @Dependency(\.accountAPI) var api
        @Dependency(\.tokenStorage) var tokenStorage

        return AccountService(
            hasValidToken: {
                let credential = try await tokenStorage.loadToken()
                return credential.accessTokenExpiration > Date()
            },
            login: { accessToken in
                let credential = try await api.login(accessToken)

                await tokenStorage.save(token: credential)
            },
            logout: {
                try await api.logout()
                await tokenStorage.deleteToken()
            },
            leave: {
                try await api.leave()
                await tokenStorage.deleteToken()
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
