//
//  AccountCredential.swift
//  FullCarKit
//
//  Created by Sunny on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

struct AccountCredential: Codable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiration: Date
}
