//
//  Dependencies.swift
//  MyPlugin
//
//  Created by 한상진 on 12/10/23.
//

import Foundation
import ProjectDescription

public extension TargetDependency {
    static let fullCarKit: TargetDependency = .project(target: "FullCarKit", path: .relativeToRoot("Targets/FullCarKit"))
    static let fullCarUI: TargetDependency = .project(target: "FullCarUI", path: .relativeToRoot("Targets/FullCarUI"))
}

public extension TargetDependency {
    static let dependencies: TargetDependency = .external(name: "Dependencies")
    static let dependenciesMacros: TargetDependency = .external(name: "DependenciesMacros")
    static let alamofire: TargetDependency = .external(name: "Alamofire")
    static let crashlytics: TargetDependency = .external(name: "FirebaseCrashlytics")
    static let analytics: TargetDependency = .external(name: "FirebaseAnalytics")
}

public extension Package {
    static let firebase: Self = .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "10.19.0"))
    static let dependencies: Self = .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "1.1.2"))
    static let alamofire: Self = .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.8.1"))
}
