//
//  AuthResponse.swift
//  FullCarKit
//
//  Created by Sunny on 1/17/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

struct AuthResponse: Decodable {
    let status: Int
    let message: String
    let accountCredential: AccountCredential

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case accountCredential = "data"
    }
}
