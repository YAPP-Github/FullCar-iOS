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
    public var login: (_ socialType: SocialType, _ request: AuthRequestable) async throws -> Void
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

                guard credential.accessTokenExpiration > Date() else {
                    let response = try await api.refresh(credential.refreshToken)
                    let newCredential: AccountCredential = .init(
                        accessToken: response.accessToken,
                        refreshToken: response.refreshToken
                    )
                    await tokenStorage.save(token: newCredential)

                    return true
                }

                return true
            },
            login: { socialType, request in
                let credential = try await api.login(socialType, request)
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

#if DEBUG
extension AccountService: TestDependencyKey {
    static public var testValue: AccountService {
        @Dependency(\.accountAPI) var api
        @Dependency(\.tokenStorage) var tokenStorage

        return AccountService(
            hasValidToken: { return false },
            login: { type, accessToken in
                let credential = AccountCredential(
                    accessToken: "Test Access Token",
                    refreshToken: "Test Refresh Token"
                )
                await tokenStorage.save(token: credential)
            },
            logout: { },
            leave: { }
        )
    }
}
#endif

extension DependencyValues {
    public var accountService: AccountService {
        get { self[AccountService.self] }
        set { self[AccountService.self] = newValue }
    }
}
