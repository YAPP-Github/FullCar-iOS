//
//  ChipButtonStyle.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct ChipButtonStyle: ButtonStyle {
    @Environment(\.isSelected) private var isSelected

    private let padding: CGFloat = 14
    private let radius: CGFloat = 50

    public init() { }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(pretendard: isSelected ? .body6 : .body7)
            .padding(padding)
            .foregroundStyle(isSelected ? Color.fullCar_primary : Color.black80)
            .background(isSelected ? Color.fullCar_secondary : Color.white)
            .cornerRadius(radius: radius, corners: .allCorners)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .inset(by: 0.5)
                    .stroke(isSelected ? Color.fullCar_primary : Color.gray30, lineWidth: 1)
            )
    }
}

#Preview {
    Button(action: {}, label: {
        Text("Button")
    })
    .buttonStyle(.chip)
    .isSelected(false)
}
