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

final class FullCarAccount: NSObject {
    @Dependency(\.accountService.login) var login

    var appleAuthorizationHandler: ((Result<Void, Error>) -> ())?

    private var continuation: CheckedContinuation<String, Error>?

    @MainActor
    func kakaoLogin() async throws {
        if self.continuation == nil {
            let accessToken: String = try await withCheckedThrowingContinuation { continuation in
                authenticateWithKakao()
                self.continuation = continuation
            }
            try await login(accessToken)

            self.continuation = nil
        } else {
            throw LoginError.continuationAlreadySet
        }
    }

    func appleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = []

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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

extension FullCarAccount: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let rootViewController = windowScenes?.keyWindow?.rootViewController

        return (rootViewController?.view.window!)!
    }
}

extension FullCarAccount: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let token = String(data: identityToken, encoding: .utf8) else {
            appleAuthorizationHandler?(.failure(LoginError.appleTokenNil))
            // 일케 변경하는건?
//            continuation?.resume(throwing: LoginError.appleTokenNil)
            return
        }

        Task {
            try await login(token)
            appleAuthorizationHandler?(.success(()))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleAuthorizationHandler?(.failure(error))
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

extension FullCarAccount: DependencyKey {
    static var liveValue: FullCarAccount = .init()
}

extension DependencyValues {
    var fullCarAccount: FullCarAccount {
        get { self[FullCarAccount.self] }
        set { self[FullCarAccount.self] = newValue }
    }
}
