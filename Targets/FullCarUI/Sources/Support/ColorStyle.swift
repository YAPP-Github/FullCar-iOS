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
    let main: Color
    let background: Color
    let border: Color

    init(
        main: Color,
        background: Color,
        border: Color? = nil
    ) {
        self.main = main
        self.background = background
        self.border = border ?? main
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
        case .primary: return .init(main: .fullCar_primary, background: .fullCar_secondary)
        case .green: return .init(main: .green100, background: .green50)
        case .red: return .init(main: .red100, background: .red50)
        case .gray: return .init(main: .gray60, background: .gray30)
        case .black: return .init(main: .black80, background: .white, border: .gray30)
        }
    }
}
