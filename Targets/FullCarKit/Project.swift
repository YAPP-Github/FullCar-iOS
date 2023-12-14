import MyPlugin
import Foundation
import ProjectDescription

let project: Project = .framework(
    name: "FullCarKit",
    settings: .settings(
        base: [
            "OTHER_LDFLAGS": "-Objc -all_load $(inherited)",
        ], 
        configurations: [
            .debug(name: .sandbox), 
            .release(name: .store),
        ], 
        defaultSettings: .recommended
    ),
    targets: [
        fullCarKit
    ]
)

