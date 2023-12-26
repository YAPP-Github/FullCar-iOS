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
    public var logout: () -> Void
    public var leave: () async -> Void
    public var refresh: (_ accessToken: String, _ refreshToken: String) async -> Void
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
                let response = api.login(accessToken)

                switch response {
                case .success(let token):
                    // 서버에서 받아온 access token과 유효기간, refresh token 저장
                    let credential = AccountCredential(
                        accessToken: token,
                        refreshToken: "refresh Token",
                        accessTokenExpiration: Date()
                    )
                    await tokenStorage.save(token: credential)
                case .failure(let error):
                    throw error
                }
            },
            logout: {
                api.logout()
            },
            leave: {
                api.leave()
                await tokenStorage.deleteToken()
            },
            refresh: { accessToken, refreshToken in
                let response = api.refresh(accessToken, refreshToken)

                // 서버에서 받아온 access token update
                let credential = AccountCredential(
                    accessToken: "재발급 access Token",
                    refreshToken: "refresh Token",
                    accessTokenExpiration: Date()
                )
                await tokenStorage.save(token: credential)
            })
    }
}

extension DependencyValues {
    public var accountService: AccountService {
        get { self[AccountService.self] }
        set { self[AccountService.self] = newValue }
    }
}
