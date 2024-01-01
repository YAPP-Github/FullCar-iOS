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

    private let verticalPadding: CGFloat = 11
    private let horizontalPadding: CGFloat = 14
    private let radius: CGFloat = 50

    public init() { }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(pretendard: isSelected ? .body6 : .body7)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
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

struct ChipButtonStylePreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button(action: {}, label: {
                Text("여성")
            })
            .buttonStyle(.chip)
            .isSelected(false)

            Button(action: {}, label: {
                Text("공개안함")
            })
            .buttonStyle(.chip)
            .isSelected(true)
        }
    }
}
