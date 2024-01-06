//
//  TextFieldStyle+.swift
//  FullCarUI
//
//  Created by Sunny on 1/7/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

extension TextFieldStyle where Self == CheckTextFieldStyle {
    public static func check(
        isChecked: Binding<Bool>,
        padding: CGFloat = 16,
        backgroundColor: Color = .gray5,
        borderColor: Color,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 10
    ) -> CheckTextFieldStyle {
        return CheckTextFieldStyle(
            isChecked: isChecked,
            padding: padding,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            radius: cornerRadius
        )
    }
}
