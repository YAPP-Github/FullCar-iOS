//
//  Color+FullCar.swift
//  FullCarUI
//
//  Created by Sunny on 12/28/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI

// MARK: GrayScale
public extension Color {
    static let gray5: Color = .init(uiColor: .init(hex: "FAFAFB"))
    static let gray10: Color = .init(uiColor: .init(hex: "F7F7FA"))
    static let gray20: Color = .init(uiColor: .init(hex: "F4F4F4"))
    static let gray30: Color = .init(uiColor: .init(hex: "ECECEC"))
    static let gray40: Color = .init(uiColor: .init(hex: "D6D2CD"))
    static let gray45: Color = .init(uiColor: .init(hex: "B7B7B7"))
    static let gray50: Color = .init(uiColor: .init(hex: "B1B8C0"))
    static let gray60: Color = .init(uiColor: .init(hex: "505967")).opacity(0.69)
    static let black80: Color = .init(uiColor: .init(hex: "242424"))
}

// MARK: Main Color
public extension Color {
    static let fullCar_primary: Color = .init(uiColor: .init(hex: "6C7AF1"))
    static let fullCar_secondary: Color = .init(uiColor: .init(hex: "E1E4FE"))
    static let fullCar_primary_background50: Color = .init(uiColor: .init(hex: "F4F5FF"))
}

// MARK: System Color
public extension Color {
    static let red100: Color = .init(uiColor: .init(hex: "FF4B4B"))
    static let red50: Color = .init(uiColor: .init(hex: "FEE8E1"))

    static let green100: Color = .init(uiColor: .init(hex: "00CF85"))
    static let green50: Color = .init(uiColor: .init(hex: "E1FEE9"))
}
