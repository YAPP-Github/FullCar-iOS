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
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG SANDBOX",
                "OTHER_LDFLAGS": "-Objc $(inherited)",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                "CODE_SIGN_ENTITLEMENTS": "FullCarSandbox.entitlements",
                "CODE_SIGN_IDENTITY": "Apple Development",
                "DEVELOPMENT_TEAM": "ZMXTCSPNUZ",
                "PROVISIONING_PROFILE_SPECIFIER": "FullCar - Develop",
//                "APP_UNIVERSAL_LINKS": "",
            ],
            xcconfig: .relativeToRoot("Targets/FullCar/Resources/APIKeys.xcconfig")
        ),
        .release(
            name: .store,
            settings: [
                "ENABLE_TESTABILITY": "NO",
                "APP_CONFIGURATION": "release",
                "PRODUCT_NAME": "FullCar",
                "PRODUCT_BUNDLE_IDENTIFIER": "com.fullcar.app.store",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE STORE",
                "OTHER_LDFLAGS": "-Objc $(inherited)",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                "CODE_SIGN_ENTITLEMENTS": "FullCarStore.entitlements",
                "CODE_SIGN_IDENTITY": "Apple Distribution",
                "DEVELOPMENT_TEAM": "ZMXTCSPNUZ",
                "PROVISIONING_PROFILE_SPECIFIER": "FullCar - AppStore",
//                /// 아직 없는데 추가해야하는 아이들
//                "APP_UNIVERSAL_LINKS": "",
            ],
            xcconfig: .relativeToRoot("Targets/FullCar/Resources/APIKeys.xcconfig")
        )
    ]
}

public extension ConfigurationName {
    static let sandbox: ConfigurationName = .init(stringLiteral: "Sandbox")
    static let store: ConfigurationName = .init(stringLiteral: "Store")
}
