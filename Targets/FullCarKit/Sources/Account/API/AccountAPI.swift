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
    var login: (_ accessToken: String) async throws -> AccountCredential
    var logout: () async throws -> Void
    var leave: () async throws -> Void
    var refresh: (_ refreshToken: String) async throws -> AccountCredential
}

extension AccountAPI: DependencyKey {
    static var liveValue: AccountAPI {
        return  AccountAPI(
            login: { accessToken in
                // 추후 서버에서 받아온 데이터 타입으로 설정
                let newCredential: AccountCredential = try await NetworkClient.main.request(
                    endpoint: Endpoint.Account.login(accessToken: accessToken)
                ).response()
                return newCredential
            },
            logout: {
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Account.logout,
                    interceptor: NetworkClient.tokenInterceptor
                ).response()
            },
            leave: {
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Account.leave,
                    interceptor: NetworkClient.tokenInterceptor
                ).response()
            },
            refresh: { refreshToken in
                let newCredential: AccountCredential = try await NetworkClient.main.request(
                    endpoint: Endpoint.Account.refresh(refreshToken: refreshToken)
                ).response()
                return newCredential
            })
    }
}

extension DependencyValues {
    var accountAPI: AccountAPI {
        get { self[AccountAPI.self] }
        set { self[AccountAPI.self] = newValue }
    }
}
