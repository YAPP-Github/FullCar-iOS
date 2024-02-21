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
        private var register: @Sendable (String, String, Int, String, String?) async throws  -> CommonResponse<Model.Information>
        
        func fetch(page: Int, size: Int = 20) async throws -> CommonResponse<Model.Fetch> {
            return try await self.fetch(page, size)
        }
        
        @discardableResult
        func register(
            pickupLocation: String,
            periodType: CarPull.Model.PeriodType,
            money: Int,
            content: String,
            moodType: Driver.Mood?
        ) async throws -> Model.Information {
            return try await self.register(pickupLocation, periodType.rawValue, money, content, moodType?.rawValue).data
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
        register: { pickupLocation, periodType, money, content, moodType in
            return try await NetworkClient.main.request(
                endpoint: Endpoint.CarPull.register(
                    pickupLocation: pickupLocation,
                    periodType: periodType,
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
        fetch: {
            _, _ in
            try? await Task.sleep(for: .seconds(1))
            if Bool.random() {
        throw NSError(domain: "", code: 1)
    } else {
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
                ], isLast: false
            )
        )
    }
        },
        register: {
            _,
            _,
            _,
            _,
            _ in
            return .init(status: 200, message: "", data: .init(
                id: 200,
                pickupLocation: "장지역 2번 출구",
                periodType: .once,
                money: 20000,
                content: "123123",
                moodType: .quiet,
                formState: .ACCEPT,
                carpoolState: .OPEN,
                nickname: "알뜰한 물개",
                companyName: "카카오페이",
                gender: .male,
                resultMessage: nil,
                createdAt: .now
            ))
        }
    )
    #endif
}

extension DependencyValues {
    var carpullAPI: CarPull.API {
        get { self[CarPull.API.self] }
        set { self[CarPull.API.self] = newValue }
    }
}
