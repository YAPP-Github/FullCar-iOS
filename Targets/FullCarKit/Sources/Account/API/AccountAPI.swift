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
    var register: (_ deviceToken: String) async throws -> Void
}

extension AccountAPI: DependencyKey {
    static var liveValue: AccountAPI {
        return  AccountAPI(
            login: { socialType, request in
                let endpoint: URLRequestConfigurable
                switch socialType {
                case .kakao:
                    guard let request = request as? KakaoAuthRequest else { throw AccountAPIError.invalidAuthRequest }

                    endpoint = Endpoint.Account.Login.kakao(request)
                case .apple:
                    guard let request = request as? AppleAuthRequest else { throw AccountAPIError.invalidAuthRequest }

                    endpoint = Endpoint.Account.Login.apple(request)
                }

                let response: CommonResponse<AuthResponse> = try await NetworkClient.account.request(
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
                    endpoint: Endpoint.Account.logout
                ).response()
            },
            leave: {
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Account.leave
                ).response()
            },
            refresh: { refreshToken in
                let response: CommonResponse<AuthTokenResponse> = try await NetworkClient.account.request(
                    endpoint: Endpoint.Account.refresh(refreshToken: refreshToken)
                ).response()

                return response.data
            },
            register: { deviceToken in
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Account.register(deviceToken: deviceToken)
                ).response()
            }
        )
    }
}

extension DependencyValues {
    var accountAPI: AccountAPI {
        get { self[AccountAPI.self] }
        set { self[AccountAPI.self] = newValue }
    }
}

extension AccountAPI {
    enum AccountAPIError: Error {
        case invalidAuthRequest
    }
}
