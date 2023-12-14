//
//  Project+.swift
//  MyPlugin
//
//  Created by 한상진 on 12/10/23.
//

import ProjectDescription

public extension Project {
    static func framework(
        name: String,
        settings: ProjectDescription.Settings? = .defaultSetting,
        targets: [ProjectDescription.Target] = [],
        testTargets: [ProjectDescription.TargetReference] = []
    ) -> Project {
        return .init(
            name: name,
            organizationName: .organizationName,
            options: .options(
                automaticSchemesOptions: 
                        .disabled,
                disableBundleAccessors: false,
                disableSynthesizedResourceAccessors: true
            ),
            settings: settings,
            targets: targets,
            schemes: [
                .makeScheme(name: name, for: .sandbox),
            ]
        )
    }
}
