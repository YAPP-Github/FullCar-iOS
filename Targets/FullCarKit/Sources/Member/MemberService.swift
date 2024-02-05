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
    public var locationSearch: (_ location: String, _ key: String) async throws -> [LocalCoordinate]
}

extension MemberService: DependencyKey {
    public static var liveValue: MemberService {
        @Dependency(\.memberAPI) var api

        return MemberService(
            locationSearch: { location,key in
                let coordinate = try await api.locationSearch(location, key)
                return coordinate
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
