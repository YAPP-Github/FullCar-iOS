//
//  AuthResponse.swift
//  FullCarKit
//
//  Created by Sunny on 1/17/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

struct ApiAuthResponse: Decodable {
    let status: Int
    let message: String
    let data: AuthResponse
}

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
