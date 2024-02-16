//
//  MemberAPI.swift
//  FullCarKit
//
//  Created by Sunny on 2/5/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import Dependencies

public struct MemberAPI {
    public var searchLocation: (_ location: String, _ key: String) async throws -> [LocalCoordinate]
    public var checkNickname: (_ nickname: String) async throws -> Void
    public var register: (_ member: MemberInformation) async throws -> Void
    public var send: (_ email: String) async throws -> Void
    public var verify: (_ code: String) async throws -> Void
    public var fetch: () async throws -> MemberInformation
}

extension MemberAPI: DependencyKey {
    public static var liveValue: MemberAPI {
        return MemberAPI(
            searchLocation: { location, key in
                let response: LocationResponse = try await NetworkClient.account.request(
                    endpoint: Endpoint.Member.search(location: location, key: key)
                ).response()
                let coordinates: [LocalCoordinate] = response.locations.compactMap { location in
                    return LocalCoordinate(
                        name: location.placeName,
                        address: location.roadAddressName,
                        latitude: Double(location.y) ?? .zero,
                        longitude: Double(location.x) ?? .zero
                    )
                }

                return coordinates
            },
            checkNickname: { nickname in
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Member.check(nickname: nickname)
                ).response()
            },
            register: { member in
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Member.register(member: member)
                ).response()
            },
            send: { email in
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Member.send(email: email)
                ).response()
            },
            verify: { code in
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Member.verify(code: code)
                ).response()
            },
            fetch: {
                let response: CommonResponse<MemberResponse> = try await NetworkClient.main.request(
                    endpoint: Endpoint.Member.fetch
                ).response()

                return response.data.toDomain()
            }
        )
    }
}

extension DependencyValues {
    public var memberAPI: MemberAPI {
        get { self[MemberAPI.self] }
        set { self[MemberAPI.self] = newValue }
    }
}
