//
//  CheckTextFieldStyle.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct CheckTextFieldStyle: TextFieldStyle {
    private let padding: CGFloat
    private let backgroundColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    private let cornerRadius: CGFloat

    @Binding private var isChecked: Bool

    public typealias Configuration = TextField<Self._Label>

    public func _body(configuration: Configuration) -> some View {
        HStack {
            configuration

            if isChecked {
                Image(icon: .check)
                    .resizable()
                    .frame(iconSize: ._24)
                    .foregroundStyle(Color.green100)
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }
}

public extension CheckTextFieldStyle {
    init(
        isChecked: Binding<Bool>,
        padding: CGFloat,
        backgroundColor: Color,
        borderColor: Color,
        borderWidth: CGFloat,
        radius: CGFloat
    ) {
        self._isChecked = isChecked
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = radius
    }
}
