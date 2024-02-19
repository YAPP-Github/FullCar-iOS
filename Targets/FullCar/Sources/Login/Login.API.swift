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

        private var continuation: CheckedContinuation<LoginResponse, Error>?

        func performLogin(_ type: SocialType) async throws {
            if let continuation {
                self.continuation = nil
            }

            let loginResponse: LoginResponse = try await authenticate(type)
            let request: AuthRequestable = try createAuthRequest(type, loginResponse: loginResponse)

            try await accountService.login(type, request)
        }

        private func authenticate(_ type: SocialType) async throws -> LoginResponse {
            let loginResponse: (token: String, authCode: String?) = try await withCheckedThrowingContinuation { continuation in
                switch type {
                case .kakao:
                    Task {
                        await authenticateWithKakao()
                    }
                case .apple: configureAppleLogin()
                }
                self.continuation = continuation
            }

            return loginResponse
        }

        private func createAuthRequest(_ type: SocialType, loginResponse: LoginResponse) throws -> AuthRequestable {
            switch type {
            case .kakao:
                return KakaoAuthRequest(
                    token: loginResponse.token
                )
            case .apple:
                return AppleAuthRequest(
                    authCode: loginResponse.authCode ?? "",
                    idToken: loginResponse.token
                )
            }
        }

        @MainActor
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
                    self.continuation?.resume(returning: (accessToken, nil))
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
              let authorizationCode = credential.authorizationCode,
              let idToken = String(data: identityToken, encoding: .utf8),
              let authCode = String(data: authorizationCode, encoding: .utf8) else {
            continuation?.resume(throwing: LoginError.appleTokenNil)
            continuation = nil
            return
        }

        continuation?.resume(returning: (idToken, authCode))
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

fileprivate extension Login.API {
    typealias LoginResponse = (token: String, authCode: String?)
}
