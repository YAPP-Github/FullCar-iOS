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
    public var login: (_ request: AuthRequest) async throws -> Void
    public var logout: () async throws -> Void
    public var leave: () async throws -> Void
}

extension AccountService: DependencyKey {
    public static var liveValue: AccountService {
        @Dependency(\.accountAPI) var api
        @Dependency(\.tokenStorage) var tokenStorage

        return AccountService(
            hasValidToken: {
                // 1. 기존 토큰 가져오기
                let credential = try await tokenStorage.loadToken()

                // 2. 기존 토큰이 존재한다면 access token 유효한지 확인
                guard credential.accessTokenExpiration > Date() else {
                    // 3. 새로운 refresh token으로 access token 재발급
                    let response = try await api.refresh(credential.refreshToken)
                    let newCredential: AccountCredential = .init(
                        onBoardingFlag: credential.onBoardingFlag,
                        accessToken: response.accessToken,
                        refreshToken: response.refreshToken
                    )
                    await tokenStorage.save(token: newCredential)

                    // 4. 만약 refresh token 또한 유효하지 않다면 throws 전달
                    return true
                }

                return true
            },
            login: { request in
                let credential = try await api.login(request)
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
            login: { accessToken in
                let credential = AccountCredential(
                    onBoardingFlag: false,
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
