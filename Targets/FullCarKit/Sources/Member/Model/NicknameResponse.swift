//
//  NicknameResponse.swift
//  FullCarKit
//
//  Created by Sunny on 2/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

struct ApiNicknameResponse: Decodable {
    let status: Int
    let message: String
    let data: NicknameResponse
}

struct NicknameResponse: Decodable {
    let nickname: String
}
