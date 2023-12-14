//
//  Settings+.swift
//  MyPlugin
//
//  Created by 한상진 on 12/15/23.
//

import Foundation
import ProjectDescription

public extension Settings {
    static let defaultSetting: Settings = .settings(
        configurations: [
            .debug(name: .sandbox),
            .release(name: .store),
        ]
    )
}
