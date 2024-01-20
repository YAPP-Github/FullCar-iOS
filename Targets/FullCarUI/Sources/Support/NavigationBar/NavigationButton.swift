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
    private let icon: FCIcon.Symbol
    private let iconColor: Color
    private let iconSize: FCIcon.Size
    private let action: () -> Void

    public init(
        icon: FCIcon.Symbol,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconColor = .black80
        self.iconSize = ._24
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            Image(icon: icon)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(iconColor)
                .frame(iconSize: iconSize)
        })
    }
}
