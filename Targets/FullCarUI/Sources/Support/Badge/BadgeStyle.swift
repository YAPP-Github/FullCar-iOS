//
//  BadgeStyle.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// Badge의 색상 스타일에 관한 타입입니다.
public struct BadgeStyle {
    let textColor: Color
    let backgroundColor: Color

    enum Colors {
        case primary
        case green
        case red
        case gray
    }

    static func colorPalette(_ colorType: Colors) -> BadgeStyle {
        switch colorType {
        case .primary: return .init(textColor: .fullCar_primary, backgroundColor: .fullCar_secondary)
        case .green: return .init(textColor: .green100, backgroundColor: .green50)
        case .red: return .init(textColor: .red100, backgroundColor: .red50)
        case .gray: return .init(textColor: .gray60, backgroundColor: .gray30)
        }
    }
}
