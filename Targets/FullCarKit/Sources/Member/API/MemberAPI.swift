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
                let response: ApiNicknameResponse = try await NetworkClient.main.request(
                    endpoint: Endpoint.Member.check(nickname: nickname)
                ).response()
                // MARK: 닉네임 중복 검사 이후 Retrun 필요한가?
            },
            register: { member in
                try await NetworkClient.main.request(
                    endpoint: Endpoint.Member.register(member: member)
                ).response()
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
