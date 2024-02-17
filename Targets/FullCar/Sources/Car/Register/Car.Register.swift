//
//  Car.Register.swift
//  FullCar
//
//  Created by 한상진 on 2/3/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

import FullCarKit
import Dependencies
import XCTestDynamicOverlay

extension Car {
    enum Register { }
}

extension Car.Register {
    struct API {
        private var fetch: @Sendable (String, String, String, String) async throws -> CommonResponse<Car.Information>
        
        func fetch(carNumber: String, carName: String, carBrand: String, carColor: String) async throws -> Car.Information {
            let response: CommonResponse<Car.Information> = try await self.fetch(carNumber, carName, carBrand, carColor)
            return response.data
        }
    }
}

extension Car.Register.API: DependencyKey {
    static let liveValue: Car.Register.API = .init { carNo, carName, carBrand, carColor in
        return try await NetworkClient.main.request(endpoint: Endpoint.Car.fetch(carNo: carNo, carName: carName, carBrand: carBrand, carColor: carColor))
            .response()
    }
    #if DEBUG
    static let previewValue: Car.Register.API = .init { carNo, carName, carBrand, carColor in
        try? await Task.sleep(for: .seconds(1)) 
        return .init(status: 200, message: "", data: .mock)
    }
    #endif
}

extension DependencyValues {
    var carRegisterAPI: Car.Register.API {
        get { self[Car.Register.API.self] }
        set { self[Car.Register.API.self] = newValue }
    }
}
