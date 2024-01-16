//
//  AccountCredential.swift
//  FullCarKit
//
//  Created by Sunny on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

struct AccountCredential: Codable {
    var onBoardingFlag: Bool
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiration: Date
    
    enum CodingKeys: CodingKey {
        case onBoardingFlag
        case accessToken
        case refreshToken
    }

    init(onBoardingFlag: Bool, accessToken: String, refreshToken: String) {
        self.onBoardingFlag = onBoardingFlag
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.accessTokenExpiration = Date().addingTimeInterval(1.9 * 3600)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onBoardingFlag = try container.decode(Bool.self, forKey: .onBoardingFlag)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        accessTokenExpiration = Date().addingTimeInterval(1.9 * 3600)
    }
}
