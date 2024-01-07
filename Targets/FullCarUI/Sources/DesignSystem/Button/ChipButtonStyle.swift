//
//  ChipButtonStyle.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct ChipButtonStyle: ButtonStyle {
    @Binding private var isSelected: Bool

    public init(isSelected: Binding<Bool>) {
        self._isSelected = isSelected
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(pretendard: isSelected ? .bold15: .medium15)
            .padding(.vertical, Constants.verticalPadding)
            .padding(.horizontal, Constants.horizontalPadding)
            .foregroundStyle(style.dark)
            .background(style.light)
            .cornerRadius(radius: Constants.radius, corners: .allCorners)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.radius)
                    .inset(by: 0.5)
                    .stroke(style.extra, lineWidth: 1)
            )
    }

    private var style: ColorStyle {
        switch isSelected {
        case true: return .palette(.primary_secondary)
        case false: return .palette(.black)
        }
    }
}

extension ChipButtonStyle {
    enum Constants {
        static let verticalPadding: CGFloat = 11
        static let horizontalPadding: CGFloat = 14
        static let radius: CGFloat = 50
    }
}

struct ChipButtonStylePreviews: PreviewProvider {

    @State static var isSelected_firstButton: Bool = true
    @State static var isSelected_secondButton: Bool = false

    static var previews: some View {
        VStack {
            Button(action: {
                self.isSelected_firstButton.toggle()
            }, label: {
                Text("여성")
            })
            .buttonStyle(.chip($isSelected_firstButton))


            Button(action: {
                self.isSelected_secondButton.toggle()
            }, label: {
                Text("공개안함")
            })
            .buttonStyle(.chip($isSelected_secondButton))
        }
    }
}
