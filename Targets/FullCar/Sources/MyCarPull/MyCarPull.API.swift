//
//  MyCarPull.API.swift
//  FullCar
//
//  Created by Tabber on 2024/02/20.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarUI
import FullCarKit
import Dependencies
import XCTestDynamicOverlay

extension MyCarPullListView {
    struct API {
        private var fetch: @Sendable () async throws -> CommonResponse<[CarPull.Model.Information]>
        
        func fetch() async throws -> CommonResponse<[CarPull.Model.Information]> {
            return try await self.fetch()
        }
    }
}

extension MyCarPullListView.API: DependencyKey {
    static let liveValue: MyCarPullListView.API = .init(fetch: {
        return try await NetworkClient.main.request(endpoint: Endpoint.CarPull.fetchMyCarPulls)
            .response()
    })
    
    #if DEBUG
    static let previewValue: MyCarPullListView.API = .init(fetch: {
        return CommonResponse<[CarPull.Model.Information]>(
            status: 200, message: "", data: [.mock()]
        )
    })
    #endif
}

extension DependencyValues {
    var myCarPullAPI: MyCarPullListView.API {
        get { self[MyCarPullListView.API.self] }
        set { self[MyCarPullListView.API.self] = newValue }
    }
}
