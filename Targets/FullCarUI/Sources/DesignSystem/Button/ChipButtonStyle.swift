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

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(pretendard: isSelected ? .body6 : .body7)
            .padding(.vertical, Constants.verticalPadding)
            .padding(.horizontal, Constants.horizontalPadding)
            .foregroundStyle(isSelected ? Colors.fontColor : Colors.deselectedFontColor)
            .background(isSelected ? Colors.backgroundColor : Colors.deselectedBackgroundColor)
            .cornerRadius(radius: Constants.radius, corners: .allCorners)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.radius)
                    .inset(by: 0.5)
                    .stroke(isSelected ? Color.fullCar_primary : Color.gray30, lineWidth: 1)
            )
    }
}

extension ChipButtonStyle {
    enum Constants {
        static let verticalPadding: CGFloat = 11
        static let horizontalPadding: CGFloat = 14
        static let radius: CGFloat = 50
    }

    enum Colors {
        static let textColor = Color.white
        static let backgroundColor = Color.fullCar_secondary
        static let deselectedBackgroundColor = Color.white
        static let fontColor = Color.fullCar_primary
        static let deselectedFontColor = Color.black80
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
