//
//  Login.swift
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

struct Login {
    @Dependency(\.accountService) var account

    func kakaoLogin(completion: @escaping () -> Void) async {
        do {
            let accessToken = try await self.authenticateWithKakao()
            try account.login(accessToken: accessToken)
            
            completion()
        } catch {
            print(error)
        }
    }

    func appleLogin(result: Result<ASAuthorization, Error>, completion: @escaping () -> Void) {
        if case let .success(authorization) = result {
            do {
                guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                      let identityToken = credential.identityToken,
                      let token = String(data: identityToken, encoding: .utf8) else { return }
                try account.login(accessToken: token)

                completion()
            } catch {
                print(error)
            }
        }
    }

    private func authenticateWithKakao() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let completion: ((OAuthToken?, Error?) -> Void) = { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let accessToken = token?.accessToken else {
                        continuation.resume(throwing: LoginError.kakaoTokenNil)
                        return
                    }
                    continuation.resume(returning: accessToken)
                }
            }

            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk(completion: completion)
                } else {
                    UserApi.shared.loginWithKakaoAccount(completion: completion)
                }
            }
        }
    }
}

extension Login {
    enum LoginType: String {
        case kakao
        case apple
    }

    enum LoginError: Error {
        case kakaoTokenNil
    }
}

extension DependencyValues {
    var login: Login {
        get { self[Login.self] }
        set { self[Login.self] = newValue }
    }
}

extension Login: DependencyKey {
    static var liveValue: Login = .init()
}
