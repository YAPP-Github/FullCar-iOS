//
//  ColorStyle.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 자주 사용하는 색상 조합 타입입니다.
public struct ColorStyle {
    let foreground: Color
    let background: Color
    let extra: Color

    init(
        foreground: Color,
        background: Color,
        extra: Color? = nil
    ) {
        self.foreground = foreground
        self.background = background
        self.extra = extra ?? foreground
    }
}

public extension ColorStyle {
    /// main color로 case 설정
    enum Palette {
        case primary
        case green
        case red
        case gray
        case black
    }

    static func palette(_ type: Palette) -> ColorStyle {
        switch type {
        case .primary: return .init(foreground: .fullCar_primary, background: .fullCar_secondary)
        case .green: return .init(foreground: .green100, background: .green50)
        case .red: return .init(foreground: .red100, background: .red50)
        case .gray: return .init(foreground: .gray60, background: .gray30)
        case .black: return .init(foreground: .black80, background: .white, extra: .gray30)
        }
    }
}
