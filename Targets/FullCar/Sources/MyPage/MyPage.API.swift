//
//  MyPage.API.swift
//  FullCar
//
//  Created by Sunny on 2/10/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import Dependencies

extension MyPage {
    struct API {
        private var logout: () async throws -> Void
        private var leave: () async throws -> Void

        func logout() async throws -> Void {
            return try await self.logout()
        }
        func leave() async throws -> Void {
            return try await self.leave()
        }
    }
}

extension MyPage.API: DependencyKey {
    static var liveValue: MyPage.API {
        @Dependency(\.accountService) var accountService

        return MyPage.API(
            logout: {
                try await accountService.logout()
            },
            leave: {
                try await accountService.leave()
            }
        )
    }
}

extension DependencyValues {
    var myPageAPI: MyPage.API {
        get { self[MyPage.API.self] }
        set { self[MyPage.API.self] = newValue }
    }
}
