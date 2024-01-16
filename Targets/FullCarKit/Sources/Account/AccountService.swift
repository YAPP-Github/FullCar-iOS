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
                let credential = try await tokenStorage.loadToken()
                return credential.accessTokenExpiration > Date()
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

extension AccountService: TestDependencyKey {
    static public var testValue: AccountService {
        @Dependency(\.accountAPI) var api

        return AccountService(
            hasValidToken: { return false },
            login: { accessToken in
                // 실제 서버 통신 대신 목데이터 사용
                let credential = AccountCredential(
                    onBoardingFlag: false, 
                    accessToken: "access Token",
                    refreshToken: "refresh Token"
                )
            },
            logout: { },
            leave: { }
        )
    }
}

extension DependencyValues {
    public var accountService: AccountService {
        get { self[AccountService.self] }
        set { self[AccountService.self] = newValue }
    }
}
