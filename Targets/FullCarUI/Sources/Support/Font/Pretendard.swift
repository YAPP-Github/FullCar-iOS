//
//  Pretendard.swift
//  FullCarUI
//
//  Created by Sunny on 12/27/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI

public enum Pretendard {
    public enum Style: CGFloat {
        case bold28
        case bold22
        case bold18
        case bold17
        case bold16
        case bold15
        case bold13
        case bold12

        case semibold17
        case semibold16
        case semibold14
        case semibold13
        case semibold12

        case regular16

        case medium16
        case medium15
        case medium14
    }
}

extension Pretendard.Style {
    var fontConvertible: FontConvertible {
        switch self {
        case .bold28, .bold22, .bold18, .bold17, .bold16, .bold15, .bold13, .bold12:
            return FontConvertible(
                name: "Pretendard-Bold",
                family: "Pretendard",
                path: "Pretendard-Bold.otf"
            )
        case .semibold17, .semibold16, .semibold14, .semibold13, .semibold12:
            return FontConvertible(
                name: "Pretendard-SemiBold",
                family: "Pretendard",
                path: "Pretendard-SemiBold.otf"
            )
        case .medium16, .medium15, .medium14:
            return FontConvertible(
                name: "Pretendard-Medium",
                family: "Pretendard",
                path: "Pretendard-Medium.otf"
            )
        case .regular16: 
            return FontConvertible(
                name: "Pretendard-Regular",
                family: "Pretendard",
                path: "Pretendard-Regular.otf"
            )
        }
    }

    var size: CGFloat {
        switch self {
        case .bold28: return 28
        case .bold22: return 22
        case .bold18: return 18
        case .bold17, .semibold17: return 17
        case .bold16, .semibold16, .regular16, .medium16: return 16
        case .bold15, .medium15: return 15
        case .semibold14, .medium14: return 14
        case .bold13, .semibold13: return 13
        case .bold12, .semibold12: return 12
        }
    }

    public var lineHeightSize: CGFloat {
        switch self {
        case .bold28: return 28
        case .bold22: return 34
        case .bold18: return 24
        case .bold17: return 20
        case .bold16: return 20
        case .bold15: return 18
        case .bold13: return 17
        case .bold12: return 14
        case .semibold17: return 20
        case .semibold16: return 22
        case .semibold14: return 20
        case .semibold13: return 20
        case .semibold12: return 14
        case .regular16: return 24
        case .medium16: return 20
        case .medium15: return 18
        case .medium14: return 20
        }
    }
}

extension Pretendard.Style: FontLineHeightConfigurable {
    public var font: UIFont {
        return fontConvertible.font(size: size)
    }

    public var lineHeight: CGFloat {
        return lineHeightSize
    }
}
