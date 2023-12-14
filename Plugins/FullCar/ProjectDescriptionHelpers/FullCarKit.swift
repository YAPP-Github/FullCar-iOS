//
//  FullCarKit.swift
//  MyPlugin
//
//  Created by 한상진 on 12/10/23.
//

import Foundation
import ProjectDescription

public let fullCarKit: Target = .makeModule(
    name: "FullCarKit", 
    bundleId: "com.fullcar.kit", 
    dependencies: [
        .alamofire,
        .analytics,
        .crashlytics,
        .dependencies,
    ]
)
