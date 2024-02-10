//
//  AuthRequest.swift
//  FullCarKit
//
//  Created by Sunny on 1/15/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public struct AuthRequest {
    var socialType: SocialType
    var token: String
    var deviceToken: String

    public init(socialType: SocialType, token: String, deviceToken: String) {
        self.socialType = socialType
        self.token = token
        self.deviceToken = deviceToken
    }
}
