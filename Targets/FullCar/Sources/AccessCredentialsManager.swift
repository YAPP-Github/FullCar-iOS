//
//  AccessCredentialsManager.swift
//  FullCar
//
//  Created by Sunny on 2/12/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import Dependencies

struct AccessCredentialsManager { }

extension AccessCredentialsManager {
    struct KakaoKey {
        var nativeAppKey: () throws ->  String
        var restApiKey: () throws ->  String
    }
}

extension AccessCredentialsManager {
    struct DeviceToken {
        var save: (Data) -> Void
        var fetch: () throws -> String
    }
}

extension AccessCredentialsManager.KakaoKey: DependencyKey {
    static var liveValue: AccessCredentialsManager.KakaoKey {
        return .init(
            nativeAppKey: {
                guard let kakaoNativeAppKey = Bundle.main.kakaoNativeAppKey else { throw KakaoApiKeyError.nativeAppKeyNil }
                return kakaoNativeAppKey
            },
            restApiKey: {
                guard let kakaoRestApiKey = Bundle.main.kakaoRestApiKey else { throw KakaoApiKeyError.restKeyNil }
                return kakaoRestApiKey
            }
        )
    }
}

extension AccessCredentialsManager.DeviceToken: DependencyKey {
    static var liveValue: AccessCredentialsManager.DeviceToken {
        var deviceToken: String?

        return .init(
            save: { token in
                let token = String(data: token, encoding: .utf8)
                deviceToken = token
            },
            fetch: {
                guard let deviceToken else { throw DeviceTokenError.tokenNil }
                return deviceToken
            }
        )
    }
}

extension DependencyValues {
    var kakaoKey: AccessCredentialsManager.KakaoKey {
        get { self[AccessCredentialsManager.KakaoKey.self] }
        set { self[AccessCredentialsManager.KakaoKey.self] = newValue }
    }

    var deviceToken: AccessCredentialsManager.DeviceToken {
        get { self[AccessCredentialsManager.DeviceToken.self] }
        set { self[AccessCredentialsManager.DeviceToken.self] = newValue }
    }
}

extension AccessCredentialsManager.KakaoKey {
    enum KakaoApiKeyError: Error {
        case restKeyNil
        case nativeAppKeyNil
    }
}

extension AccessCredentialsManager.DeviceToken {
    enum AccessCredentialsError: Error {
        case deviceTokenNil
    }
}
