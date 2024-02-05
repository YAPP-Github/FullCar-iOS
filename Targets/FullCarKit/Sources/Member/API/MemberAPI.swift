//
//  MemberAPI.swift
//  FullCarKit
//
//  Created by Sunny on 2/5/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import Dependencies

struct MemberAPI {
    var locationSearch: (_ location: String, _ key: String) async throws -> CompanyCoordinate
}

extension MemberAPI: DependencyKey {
    static var liveValue: MemberAPI {
        return MemberAPI(
            locationSearch: { location, key in
                let coordinate: CompanyCoordinate = try await NetworkClient.account.request(
                    endpoint: Endpoint.Member.locationSearch(location, key: key)
                ).response()
                return coordinate
            }
        )
    }

    #if DEBUG
    static let testValue: MemberAPI = .init(
        locationSearch: { _, _ in
            return .init(
                name: "네이버",
                latitude: 127.10520633434606,
                longitude: 37.3588600621634
            )
        }
    )
    #endif
}

extension DependencyValues {
    var memberAPI: MemberAPI {
        get { self[MemberAPI.self] }
        set { self[MemberAPI.self] = newValue }
    }
}
