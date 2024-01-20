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
            case .won, .search: return 14
            case .none(let padding): return padding
            }
        }

        var backgroundColor: Color {
            switch type {
            case .check, .search: return .gray5
            case .won: return .white
            case .none: return .white
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
        type: FCTextFieldStyle.AccessoryType,
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
