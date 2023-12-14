//
//  Configuration+.swift
//  MyPlugin
//
//  Created by 한상진 on 12/10/23.
//

import ProjectDescription

public extension [Configuration] {
    static let app: [Configuration] = [
        .debug(
            name: .sandbox,
            settings: [
                "ENABLE_TESTABILITY": "YES",
                "APP_CONFIGURATION": "debug",
                "PRODUCT_NAME": "FullCar",
                "PRODUCT_BUNDLE_IDENTIFIER": "com.fullcar.app.sandbox",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "APP $(inherited)",
                "OTHER_LDFLAGS": "-Objc $(inherited)",
//                // 확인 및 추가 필요
//                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
//                "CODE_SIGN_ENTITLEMENTS": "FullCar_Sandbox.entitlements",
//                "CODE_SIGN_IDENTITY": "Apple Development", 
//                // 병윤이가 추가 필요
                "DEVELOPMENT_TEAM": "CTU95JY82Q",
//                "PROVISIONING_PROFILE_SPECIFIER": "FullCar Development",
//                // 아직 없는데 추가해야하는 아이들
//                "APP_UNIVERSAL_LINKS": "",
            ]
        ),
        .release(
            name: .store,
            settings: [
                "ENABLE_TESTABILITY": "NO",
                "APP_CONFIGURATION": "release",
                "PRODUCT_NAME": "FullCar",
                "PRODUCT_BUNDLE_IDENTIFIER": "com.fullcar.app.store",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "APP $(inherited)",
                "OTHER_LDFLAGS": "-Objc $(inherited)",
//                /// 확인 및 추가 필요
//                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
//                "CODE_SIGN_ENTITLEMENTS": "FullCar_Store.entitlements",
//                "CODE_SIGN_IDENTITY": "Apple Distribution", 
//                /// 병윤이가 추가 필요
                "DEVELOPMENT_TEAM": "CTU95JY82Q",
//                "PROVISIONING_PROFILE_SPECIFIER": "FullCar Distribution",
//                /// 아직 없는데 추가해야하는 아이들
//                "APP_UNIVERSAL_LINKS": "",
            ]
        )
    ]
}

public extension ConfigurationName {
    static let sandbox: ConfigurationName = .init(stringLiteral: "Sandbox")
    static let store: ConfigurationName = .init(stringLiteral: "Store")
}
