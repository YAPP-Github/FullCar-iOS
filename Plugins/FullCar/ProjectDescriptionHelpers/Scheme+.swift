//
//  Scheme+.swift
//  MyPlugin
//
//  Created by 한상진 on 12/10/23.
//

import ProjectDescription

public extension [Scheme] {
    static let appSchemes: [Scheme] = [
        .makeScheme(name: "[Sandbox] FullCar", for: .sandbox, targets: ["FullCar"]),
        .makeScheme(name: "[Store] FullCar", for: .store, targets: ["FullCar"])
    ] 
}

public extension Scheme {
    static func makeScheme(
        name: String,
        for configuration: ConfigurationName,
        arguments: ProjectDescription.Arguments? = nil,
        diagnosticsOptions: [SchemeDiagnosticsOption] = [.mainThreadChecker, .performanceAntipatternChecker],
        targets: [TargetReference] = [],
        testTargets: [ProjectDescription.TargetReference] = []
    ) -> Scheme {
        return .init(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: targets.isEmpty ? ["\(name)"] : targets),
            testAction: .targets(
                testTargets
                    .map { TestableTarget(target: $0) },
                configuration: configuration
            ),
            runAction: .runAction(
                configuration: configuration,
                arguments: arguments,
                diagnosticsOptions: diagnosticsOptions
            ),
            archiveAction: .archiveAction(configuration: configuration),
            profileAction: .profileAction(configuration: configuration),
            analyzeAction: .analyzeAction(configuration: configuration)
        )
    }
}
