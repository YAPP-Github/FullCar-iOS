//
//  AuthTokenResponse.swift
//  FullCarKit
//
//  Created by Sunny on 1/17/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

struct ApiAuthTokenResponse: Decodable {
    let status: Int
    let message: String
    let data: AuthTokenResponse
}

struct AuthTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
