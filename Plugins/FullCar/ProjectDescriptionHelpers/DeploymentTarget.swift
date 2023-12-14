//
//  DeploymentTarget.swift
//  MyPlugin
//
//  Created by 한상진 on 12/14/23.
//

import Foundation
import ProjectDescription

public extension DeploymentTarget {
    static let app: DeploymentTarget = .iOS(targetVersion: "17.0", devices: .iphone)
}
