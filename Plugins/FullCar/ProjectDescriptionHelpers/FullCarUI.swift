//
//  FullCarUI.swift
//  MyPlugin
//
//  Created by 한상진 on 12/10/23.
//

import Foundation
import ProjectDescription

public let fullCarUI: Target = .makeModule(
    name: "FullCarUI", 
    bundleId: "com.fullcar.ui",
    infoPlist: .extendingDefault(
        with: [
            "UIAppFonts": [
                "Pretendard-Regular.otf",
                "Pretendard-Medium.otf",
                "Pretendard-SemiBold.otf",
                "Pretendard-Bold.otf"
            ]
        ]
    ),
    dependencies: []
)
