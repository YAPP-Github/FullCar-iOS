//
//  Templates.swift
//  MyPlugin
//
//  Created by 한상진 on 12/10/23.
//

import Foundation
import ProjectDescription

extension Target {
    static func makeModule(
        name: String,
        platform: Platform = .iOS,
        product: Product = .framework,
        bundleId: String,
        infoPlist: InfoPlist = .default,
        dependencies: [TargetDependency]
    ) -> Target {
        return Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: bundleId,
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [] + dependencies
        )
    }
}
