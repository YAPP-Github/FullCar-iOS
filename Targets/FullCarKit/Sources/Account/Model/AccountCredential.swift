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

    init(onBoardingFlag: Bool, accessToken: String, refreshToken: String) {
        self.onBoardingFlag = onBoardingFlag
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.accessTokenExpiration = Date().addingTimeInterval(0.9 * 3600)
    }
}
