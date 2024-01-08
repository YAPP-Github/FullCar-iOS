//
//  NavigationButton.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// NavigationBar에서 사용하는  button 입니다.
public struct NavigationButton: View {
    private let iconConfiguration: Icon.Configuration
    private let action: () -> Void

    public init(
        symbol: Icon.Symbol,
        action: @escaping () -> Void
    ) {
        self.iconConfiguration = .init(
            symbol: symbol,
            size: 24,
            color: .black80
        )
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            Icon(configuration: iconConfiguration)
        })
    }
}
