//
//  Login.API.swift
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
import FullCarKit

extension Login {
    final class API: NSObject {
        @Dependency(\.accountService) var accountService

        var hasValidToken: Bool {
            get async throws {
                return try await accountService.hasValidToken()
            }
        }

        private var continuation: CheckedContinuation<String, Error>?

        @MainActor
        func performLogin(_ type: SocialType) async throws {
            if let continuation {
                continuation.resume(throwing: LoginError.continuationAlreadySet)
                self.continuation = nil
            }

            let accessToken: String = try await withCheckedThrowingContinuation { continuation in
                switch type {
                case .kakao: authenticateWithKakao()
                case .apple: configureAppleLogin()
                }
                self.continuation = continuation
            }
            // 임시 Device token 넣어주기. 추후 수정
            let request: AuthRequest = .init(
                socialType: type,
                token: accessToken,
                deviceToken: AppDelegate.shared?.deviceToken ?? "456"
            )

            try await accountService.login(request)
        }

        private func authenticateWithKakao() {
            let completion: ((OAuthToken?, Error?) -> Void) = { token, error in
                if let error = error {
                    self.continuation?.resume(throwing: error)
                    self.continuation = nil
                } else {
                    guard let accessToken = token?.accessToken else {
                        self.continuation?.resume(throwing: LoginError.kakaoTokenNil)
                        self.continuation = nil
                        return
                    }
                    self.continuation?.resume(returning: accessToken)
                    self.continuation = nil
                }
            }

            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: completion)
            } else {
                UserApi.shared.loginWithKakaoAccount(completion: completion)
            }
        }

        private func configureAppleLogin() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = []

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

extension Login.API: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let rootViewController = windowScenes?.keyWindow?.rootViewController

        return (rootViewController?.view.window!)!
    }
}

extension Login.API: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let token = String(data: identityToken, encoding: .utf8) else {
            continuation?.resume(throwing: LoginError.appleTokenNil)
            continuation = nil
            return
        }

        continuation?.resume(returning: token)
        continuation = nil
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

extension Login.API {
    enum LoginError: Error {
        case kakaoTokenNil
        case appleTokenNil
        case continuationAlreadySet
    }
}

extension Login.API: DependencyKey {
    static var liveValue: Login.API = .init()
}

extension DependencyValues {
    var loginAPI: Login.API {
        get { self[Login.API.self] }
        set { self[Login.API.self] = newValue }
    }
}
