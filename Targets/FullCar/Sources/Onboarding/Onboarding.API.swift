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
        private var send: (_ email: String) async throws -> Void
        private var verify: (_ code: String) async throws -> Void
        private var fetch: () async throws -> MemberInformation

        func search(location: String) async throws -> [LocalCoordinate] {
            return try await self.search(location)
        }
        func check(nickname: String) async throws -> Void {
            return try await self.check(nickname)
        }
        func register(member: MemberInformation) async throws -> Void {
            return try await self.register(member)
        }
        func send(email: String) async throws -> Void {
            return try await self.send(email)
        }
        func verify(code: String) async throws -> Void {
            return try await self.verify(code)
        }
        func fetch() async throws -> MemberInformation {
            return try await self.fetch()
        }
    }
}

extension Onboarding.API: DependencyKey {
    public static var liveValue: Onboarding.API {
        @Dependency(\.memberAPI) var memberAPI
        @Dependency(\.kakaoKey) var kakaoKey

        return Onboarding.API(
            search: { location in
                let coordinate = try await memberAPI.searchLocation(location, try kakaoKey.restApiKey())
                return coordinate
            },
            check: { nickname in
                try await memberAPI.checkNickname(nickname)
            },
            register: { member in
                try await memberAPI.register(member)
            },
            send: { email in
                try await memberAPI.send(email)
            },
            verify: { code in
                try await memberAPI.verify(code)
            },
            fetch: {
                let member = try await memberAPI.fetch()

                // 유저 정보 저장
                return member
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
