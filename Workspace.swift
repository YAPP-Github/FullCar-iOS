//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by 한상진 on 12/10/23.
//

import MyPlugin
import ProjectDescription

let workspace = Workspace(
    name: .appName,
    projects: [
        "Targets/FullCar",
        "Targets/FullCarKit",
        "Targets/FullCarUI",
    ],
    generationOptions: .options(
        enableAutomaticXcodeSchemes: false,
        autogeneratedWorkspaceSchemes: .disabled,
        renderMarkdownReadme: true
    )
)
