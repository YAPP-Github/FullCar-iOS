//
//  TextFieldStyle+.swift
//  FullCarUI
//
//  Created by Sunny on 1/7/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

extension TextFieldStyle where Self == FCTextFieldStyle {
    public static func fullCar(
        type: FCTextFieldStyle.AccessoryType,
        state: Binding<InputState>,
        cornerRadius: CGFloat = 10
    ) -> FCTextFieldStyle {
        var padding: CGFloat {
            switch type {
            case .check: return 16
            case .won: return 14
            default: return 0
            }
        }

        var backgroundColor: Color {
            switch type {
            case .check: return .gray5
            case .won: return .white
            default: return .clear
            }
        }

        return FCTextFieldStyle(
            state: state,
            accessoryType: type,
            padding: padding,
            backgroundColor: backgroundColor,
            radius: cornerRadius
        )
    }

    public static func fullCar(
        type: FCTextFieldStyle.AccessoryType = .none,
        state: Binding<InputState>,
        padding: CGFloat,
        backgroundColor: Color,
        cornerRadius: CGFloat
    ) -> FCTextFieldStyle {
        return FCTextFieldStyle(
            state: state,
            accessoryType: type,
            padding: padding,
            backgroundColor: backgroundColor,
            radius: cornerRadius
        )
    }
}
