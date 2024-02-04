//
//  CarPull.API.swift
//  FullCar
//
//  Created by 한상진 on 2/5/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

import FullCarUI
import FullCarKit

import Dependencies
import XCTestDynamicOverlay

extension CarPull {
    struct API {
        private var fetch: @Sendable (Int, Int) async throws -> CommonResponse<Model.Fetch>
        private var register: @Sendable (String, String, Int, String, String) async throws  -> Model.Information
        
        func fetch(page: Int, size: Int = 20) async throws -> CommonResponse<Model.Fetch> {
            return try await self.fetch(page, size)
        }
        
        func register(
            pickupLocation: String,
            period: CarPull.Model.PeriodType,
            money: Int,
            content: String,
            moodType: Driver.Mood
        ) async throws -> Model.Information {
            return try await self.register(pickupLocation, period.rawValue, money, content, moodType.rawValue)
        }
    }
}

extension CarPull.API: DependencyKey {
    static let liveValue: CarPull.API = .init(
        fetch: { page, size in
            return try await NetworkClient.main
                .request(endpoint: Endpoint.CarPull.fetch(page: page, size: size))
                .response()
        },
        register: { pickupLocation, period, money, content, moodType in
            return try await NetworkClient.main.request(
                endpoint: Endpoint.CarPull.register(
                    pickupLocation: pickupLocation,
                    period: period,
                    money: money,
                    content: content,
                    moodType: moodType
                )
            )
            .response()
        }
    )
    #if DEBUG
    static let previewValue: CarPull.API = .init(
        fetch: { _, _ in
            return CommonResponse<CarPull.Model.Fetch>(
                status: 200,
                message: "",
                data: CarPull.Model.Fetch(
                    size: 20,
                    carPullList: [
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                        .mock(),
                    ]
                )
            )
        },
        register: { _, _, _, _, _ in
            fatalError()
//            return .init(status: 200, message: "", data: .init())
        }
    )
    #endif
}

extension DependencyValues {
    var homeAPI: CarPull.API {
        get { self[CarPull.API.self] }
        set { self[CarPull.API.self] = newValue }
    }
}
