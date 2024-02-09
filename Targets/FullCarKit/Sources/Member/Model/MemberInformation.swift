//
//  MemberInformation.swift
//  FullCarKit
//
//  Created by Sunny on 2/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public struct MemberInformation: Decodable {
    public let company: LocalCoordinate
    public let email: String
    public let nickname: String
    public let gender: String
    public var carId: Int?

    public init(company: LocalCoordinate, email: String, nickName: String, gender: String, carId: Int? = nil) {
        self.company = company
        self.email = email
        self.nickname = nickName
        self.gender = gender
        self.carId = carId
    }
}
