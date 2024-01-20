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
        private var fetch: @Sendable (String, String) async throws -> Model.Response
        
        func fetch(id: String, name: String) async throws -> Model.Response {
            return try await self.fetch(id, name)
        }
    }
    
    struct Model {
        struct Response: Decodable {
            let totalPage: Int
            let currentPage: Int
            let list: [CarPull.Model.Response]
        }
    }
}

extension Home.API: DependencyKey {
    static let liveValue: Home.API = .init(
        fetch: { id, name in
            return try await NetworkClient.main
                .request(endpoint: Endpoint.Home.fetch(id: id, name: name))
                .response()
        }
    )
    #if DEBUG
    static let testValue: Home.API = unimplemented("homeapi")
    static let previewValue: Home.API = .init(
        fetch: { _, _ in 
            return .init(
                totalPage: 10, 
                currentPage: 1,
                list: [.mock, .mock, .mock, .mock, .mock, .mock]
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
