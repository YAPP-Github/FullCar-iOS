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
    @Dependency(\.accountAPI) var api
    @Dependency(\.tokenStorage) var tokenStorage

    public var hasValidToken: Bool {
        guard let credential = tokenStorage.loadToken() else { return false }
        return credential.authTokenExpiration > Date()
    }

    public func login(accessToken: String) throws {
        let response = api.login(accessToken: accessToken)

        switch response {
        case .success(let token):
            // 서버에서 받아온 account token과 유효기간 저장
            let credential = AccountCredential(
                authToken: token,
                authTokenExpiration: Date()
            )
            tokenStorage.save(token: credential)
        case .failure(let error):
            throw error
        }
    }

    public func logout() {
        api.logout()
    }

    public func leave() {
        api.leave()
        tokenStorage.deleteToken()
    }
}

extension DependencyValues {
    public var accountService: AccountService {
        get { self[AccountService.self] }
        set { self[AccountService.self] = newValue }
    }
}

extension AccountService: DependencyKey {
    public static var liveValue: AccountService = .init()
}
