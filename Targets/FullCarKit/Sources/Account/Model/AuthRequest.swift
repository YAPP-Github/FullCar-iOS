//
//  AuthRequest.swift
//  FullCarKit
//
//  Created by Sunny on 1/15/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public enum AuthRequest { }

public extension AuthRequest {
    struct Kakao {
        var token: String
        var deviceToken: String

        public init(token: String, deviceToken: String) {
            self.token = token
            self.deviceToken = deviceToken
        }
    }
}

public extension AuthRequest {
    struct Apple {
        var authCode: String
        var idToken: String
        var deviceToken: String

        public init(authCode: String, idToken: String, deviceToken: String) {
            self.authCode = authCode
            self.idToken = idToken
            self.deviceToken = deviceToken
        }
    }
}
