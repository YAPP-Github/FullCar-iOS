//
//  MemberResponse.swift
//  FullCarKit
//
//  Created by Sunny on 2/10/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

struct MemberResponse: Decodable {
    let companyName: String?
    let nickname: String?
    let email: String?
    let gender: String?
    let carId: Int?
}

extension MemberResponse {
    func toDomain() -> MemberInformation {
        return .init(
            company: .init(name: self.companyName ?? ""),
            email: self.email ?? "",
            nickName: self.nickname ?? "",
            gender: self.gender ?? "",
            carId: self.carId
        )
    }
}
