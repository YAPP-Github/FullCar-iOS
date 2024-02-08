//
//  Onboarding.API.swift
//  FullCar
//
//  Created by Sunny on 2/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarKit
import Dependencies

extension Onboarding {
    struct API {
        private var search: (_ location: String) async throws -> [LocalCoordinate]
        private var check: (_ nickname: String) async throws -> Void
        private var register: (_ member: MemberInformation) async throws -> Void

        func search(location: String) async throws -> [LocalCoordinate] {
            return try await self.search(location)
        }
        func check(nickname: String) async throws -> Void {
            return try await self.check(nickname)
        }
        func register(member: MemberInformation) async throws -> Void {
            return try await self.register(member)
        }
    }
}

extension Onboarding.API: DependencyKey {
    public static var liveValue: Onboarding.API {
        @Dependency(\.memberAPI) var api

        return Onboarding.API(
            search: { location in
                guard let kakaoRestApiKey = Bundle.main.kakaoRestApiKey else { return [] }
                let coordinate = try await api.searchLocation(location, kakaoRestApiKey)
                return coordinate
            },
            check: { nickname in
                try await api.checkNickname(nickname)
            },
            register: { member in
                try await api.register(member)
            }
        )
    }
}

extension DependencyValues {
    var onbardingAPI: Onboarding.API {
        get { self[Onboarding.API.self] }
        set { self[Onboarding.API.self] = newValue }
    }
}
