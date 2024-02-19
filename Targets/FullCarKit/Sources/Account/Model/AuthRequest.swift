//
//  AuthRequest.swift
//  FullCarKit
//
//  Created by Sunny on 1/15/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public protocol AuthRequestable { }

public struct KakaoAuthRequest: AuthRequestable {
    var token: String

    public init(token: String) {
        self.token = token
    }
}

public struct AppleAuthRequest: AuthRequestable {
    var authCode: String
    var idToken: String

    public init(authCode: String, idToken: String) {
        self.authCode = authCode
        self.idToken = idToken
    }
}
