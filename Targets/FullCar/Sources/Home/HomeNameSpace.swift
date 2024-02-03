//
//  API.swift
//  FullCar
//
//  Created by 한상진 on 12/18/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarKit
import Dependencies

struct Home {
    struct API { 
        private var fetch: @Sendable (Int, Int) async throws -> Model.Response
        
        func fetch(page: Int, size: Int = 20) async throws -> Model.Response {
            return try await self.fetch(page, size)
        }
    }
    
    struct Model {
        struct Response: Decodable {
            let status: Int
            let message: String
            let data: Body
        }
    }
}

extension Home.Model.Response {
    struct Body: Decodable {
        let size: Int
        let carPullList: [CarPull.Model.Response]
        private enum CodingKeys: String, CodingKey {
            case size
            case carPullList = "content"
        }
    }
}

extension Home.API: DependencyKey {
    static let liveValue: Home.API = .init(
        fetch: { page, size in
            return try await NetworkClient.main
                .request(endpoint: Endpoint.Home.fetch(page: page, size: size))
                .response()
        }
    )
    #if DEBUG
    static let testValue: Home.API = unimplemented("homeapi")
    static let previewValue: Home.API = .init(
        fetch: { _, _ in
            return .init(
                status: 200,
                message: "",
                data: .init(
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
        }
    )
    #endif
}

extension DependencyValues {
    var homeAPI: Home.API {
        get { self[Home.API.self] }
        set { self[Home.API.self] = newValue }
    }
}
