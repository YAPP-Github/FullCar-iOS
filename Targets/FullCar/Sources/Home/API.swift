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
            let list: [TempCarPull]
        }
        
        struct TempCarPull: Decodable, Identifiable {
            var id: UUID = .init()
            let companyName: String
            let title: String
            let description: String
            let mood: Mood
            let state: State
        }
        
        enum State: Decodable {
            case open
            case closed
            
            var description: String {
                switch self {
                case .open: return "모집중"
                case .closed: return "마감"
                }
            }
        }
        
        enum Mood: Decodable {
            case silence
            case smallTalk
        }
    }
}

#if DEBUG
extension Home.Model.TempCarPull {
    static var mock: Self = .init(
        companyName: "카카오페이",
        title: "판교역 10시 도착",
        description: "어쩌구 저쩌구",
        mood: .silence,
        state: .open
    )
}
#endif

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
            return .init(list: [.mock, .mock, .mock])
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
