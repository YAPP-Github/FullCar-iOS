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
    var locationSearch: (_ location: String, _ key: String) async throws -> [CompanyCoordinate]
}

extension MemberAPI: DependencyKey {
    static var liveValue: MemberAPI {
        return MemberAPI(
            locationSearch: { location, key in
                let response: LocationResponse = try await NetworkClient.account.request(
                    endpoint: Endpoint.Member.locationSearch(location, key: key)
                ).response()
                let coordinates: [CompanyCoordinate] = response.locations.compactMap { location in
                    return CompanyCoordinate(
                        name: location.placeName,
                        address: location.roadAddressName,
                        latitude: Double(location.y) ?? .zero,
                        longitude: Double(location.x) ?? .zero
                    )
                }

                return coordinates
            }
        )
    }
}

extension DependencyValues {
    var memberAPI: MemberAPI {
        get { self[MemberAPI.self] }
        set { self[MemberAPI.self] = newValue }
    }
}
