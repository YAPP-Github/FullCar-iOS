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
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
        ]
    ),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: [
        .fullCarKit,
        .fullCarUI,
    ]
)
