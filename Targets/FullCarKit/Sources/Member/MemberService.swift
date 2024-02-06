//
//  MemberService.swift
//  FullCarKit
//
//  Created by Sunny on 2/5/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import Dependencies

public struct MemberService {
    public var searchLocation: (_ location: String, _ key: String) async throws -> [LocalCoordinate]
    public var checkNickname: (_ nickname: String) async throws -> Void
}

extension MemberService: DependencyKey {
    public static var liveValue: MemberService {
        @Dependency(\.memberAPI) var api

        return MemberService(
            searchLocation: { location,key in
                let coordinate = try await api.searchLocation(location, key)
                return coordinate
            },
            checkNickname: { nickname in
                try await api.checkNickname(nickname)
            }
        )
    }
}

extension DependencyValues {
    public var memberService: MemberService {
        get { self[MemberService.self] }
        set { self[MemberService.self] = newValue }
    }
}
