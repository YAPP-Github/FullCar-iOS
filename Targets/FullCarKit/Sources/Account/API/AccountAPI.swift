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
    var login: (_ socialType: SocialType, _ request: AuthRequestable) async throws -> AccountCredential
    var logout: () async throws -> Void
    var leave: () async throws -> Void
    var refresh: (_ refreshToken: String) async throws -> AuthTokenResponse
}

extension AccountAPI: DependencyKey {
    static var liveValue: AccountAPI {
        return  AccountAPI(
            login: { socialType, request in
                let endpoint: URLRequestConfigurable

                switch socialType {
                case .kakao:
                    guard let request = request as? KakaoAuthRequest else { throw LoginError.typecasting }

                    endpoint = Endpoint.Account.Login.kakao(request)
                case .apple:
                    guard let request = request as? AppleAuthRequest else { throw LoginError.typecasting }

                    endpoint = Endpoint.Account.Login.apple(request)
                }

                let response: ApiAuthResponse = try await NetworkClient.account.request(
                    endpoint: endpoint
                ).response()
                let authResponse = response.data

                return .init(
                    accessToken: authResponse.accessToken,
                    refreshToken: authResponse.refreshToken
                )
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
                let response: ApiAuthTokenResponse = try await NetworkClient.account.request(
                    endpoint: Endpoint.Account.refresh(refreshToken: refreshToken)
                ).response()

                return response.data
            })
    }
}

extension DependencyValues {
    var accountAPI: AccountAPI {
        get { self[AccountAPI.self] }
        set { self[AccountAPI.self] = newValue }
    }
}

extension AccountAPI {
    // MARK: 네이밍 수정
    enum LoginError: Error {
        case typecasting
    }
}
