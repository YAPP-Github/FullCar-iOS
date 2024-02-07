//
//  MemberInformation.swift
//  FullCarKit
//
//  Created by Sunny on 2/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public struct MemberInformation {
    public var company: LocalCoordinate
    public var email: String
    public var nickname: String
    public var gender: String

    public init(company: LocalCoordinate, email: String, nickName: String, gender: String) {
        self.company = company
        self.email = email
        self.nickname = nickName
        self.gender = gender
    }
}
