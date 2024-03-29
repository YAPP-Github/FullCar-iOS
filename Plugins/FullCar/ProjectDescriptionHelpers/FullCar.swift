//
//  FullCar.swift
//  MyPlugin
//
//  Created by 한상진 on 12/10/23.
//

import Foundation
import ProjectDescription

public let mainTarget: Target = .init(
    name: .appName,
    platform: .iOS,
    product: .app,
    bundleId: "com.fullcar.app",
    deploymentTarget: .app,
    infoPlist: .extendingDefault(
        with: [
            "CFBundleShortVersionString": "1.1",
            "CFBundleVersion": "2",
            "UIUserInterfaceStyle": "Light",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "LSApplicationQueriesSchemes": [
              "kakaokompassauth",
              "kakaolink"
            ],
            "KakaoNativeAppKey": "$(KAKAO_NATIVE_APP_KEY)",
            "KakaoRestApiKey": "$(KAKAO_REST_API_KEY)",
            "CFBundleURLTypes": [
              [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": ["kakao$(KAKAO_NATIVE_APP_KEY)"]
              ]
            ],
            // http 실행을 위한 임시 설정
            "NSAppTransportSecurity": [
                "NSAllowsArbitraryLoads": true
            ],
            "UIBackgroundModes": ["remote-notification"],
            "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        ]
    ),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: [
        .fullCarKit,
        .fullCarUI,
        .kakaoAuth,
        .kakaoCommon,
        .kakaoUser
    ]
)
