//
//  MemberResponse.swift
//  FullCarKit
//
//  Created by Sunny on 2/10/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

struct ApiMemberResponse: Decodable {
    let status: Int
    let message: String
    let data: MemberResponse
}

struct MemberResponse: Decodable {
    let nickname: String
    let companyName: String
    let email: String
    let gender: String
    let carID: CarID

    enum CodingKeys: String, CodingKey {
        case nickname, companyName, email, gender
        case carID = "carId"
    }
}

extension MemberResponse {
    func toDomain() -> MemberInformation {
        return .init(
            company: .init(name: self.companyName),
            email: self.email,
            nickName: self.nickname,
            gender: self.gender,
            carId: self.carID.id
        )
    }
}

struct CarID: Decodable {
    let id: Int
}
