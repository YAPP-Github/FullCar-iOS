//
//  FullCarAccount.swift
//  FullCar
//
//  Created by Sunny on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import Dependencies

final class FullCarAccount {
    @Dependency(\.accountService.login) var login

    private var continuation: CheckedContinuation<String, Error>?

    @MainActor
    func kakaoLogin() async throws {
        if self.continuation == nil {
            let accessToken: String = try await withCheckedThrowingContinuation { continuation in
                authenticateWithKakao()
                self.continuation = continuation
            }
            try await login(accessToken)
        } else {
            throw LoginError.continuationAlreadySet
        }
    }

    func appleLogin(result: Result<ASAuthorization, Error>) async throws {
        if case let .success(authorization) = result {
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityToken = credential.identityToken,
                  let token = String(data: identityToken, encoding: .utf8) else {
                throw LoginError.appleTokenNil
            }
            try await login(token)
        }
    }

    private func authenticateWithKakao() {
        let completion: ((OAuthToken?, Error?) -> Void) = { token, error in
            if let error = error {
                self.continuation?.resume(throwing: error)
            } else {
                guard let accessToken = token?.accessToken else {
                    self.continuation?.resume(throwing: LoginError.kakaoTokenNil)
                    return
                }
                self.continuation?.resume(returning: accessToken)
            }
        }

        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(completion: completion)
        } else {
            UserApi.shared.loginWithKakaoAccount(completion: completion)
        }
    }
}

extension FullCarAccount {
    enum LoginType: String {
        case kakao
        case apple
    }

    enum LoginError: Error {
        case kakaoTokenNil
        case appleTokenNil
        case continuationAlreadySet
    }
}

extension DependencyValues {
    var fullCarAccount: FullCarAccount {
        get { self[FullCarAccount.self] }
        set { self[FullCarAccount.self] = newValue }
    }
}

extension FullCarAccount: DependencyKey {
    static var liveValue: FullCarAccount = .init()
}
