//
//  ColorStyle.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 자주 사용하는 색상 조합 타입입니다.
public struct ColorStyle: Equatable {
    let dark: Color
    let light: Color
    let extra: Color

    public init(
        dark: Color,
        light: Color,
        extra: Color? = nil
    ) {
        self.dark = dark
        self.light = light
        self.extra = extra ?? dark
    }
}

public extension ColorStyle {
    /// dark color로 case 설정
    enum Palette {
        case primary_secondary
        case primary_white
        case green
        case red
        case gray30
        case gray60
        case black
    }

    static func palette(_ type: Palette) -> ColorStyle {
        switch type {
        case .primary_secondary: return .init(dark: .fullCar_primary, light: .fullCar_secondary)
        case .primary_white: return .init(dark: .fullCar_primary, light: .white)
        case .green: return .init(dark: .green100, light: .green50)
        case .red: return .init(dark: .red100, light: .red50)
        case .gray30: return .init(dark: .gray30, light: .white, extra: .fullCar_primary)
        case .gray60: return .init(dark: .gray60, light: .gray30)
        case .black: return .init(dark: .black80, light: .white, extra: .gray30)
        }
    }
}
