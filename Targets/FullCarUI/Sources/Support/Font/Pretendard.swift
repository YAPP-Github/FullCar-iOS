//
//  Pretendard.swift
//  FullCarUI
//
//  Created by Sunny on 12/27/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI

public enum Pretendard {
    public enum Style {
        case pretendard28(Weight)
        case pretendard22(Weight)
        case pretendard19(Weight)
        case pretendard18(Weight)
        case pretendard17(Weight)
        case pretendard16(Weight)
        case pretendard15(Weight)
        case pretendard14(Weight)
        case pretendard13(Weight)
        case pretendard12(Weight)
    }

    public enum Weight {
        case bold
        case semibold
        case regular
        case medium

        var fontConvertible: FontConvertible {
            switch self {
            case .bold: return Pretendard.bold
            case .semibold: return Pretendard.semibold
            case .regular: return Pretendard.regular
            case .medium: return Pretendard.medium
            }
        }
    }
}

extension Pretendard.Style {
    var size: CGFloat {
        switch self {
        case .pretendard28: return 28
        case .pretendard22: return 22
        case .pretendard19: return 19
        case .pretendard18: return 18
        case .pretendard17: return 17
        case .pretendard16: return 16
        case .pretendard15: return 15
        case .pretendard14: return 14
        case .pretendard13: return 13
        case .pretendard12: return 12
        }
    }

    public var lineHeightSize: CGFloat {
        switch self {
        case .pretendard28: return 28
        case .pretendard22: return 34
        case .pretendard19: return 20
        case .pretendard18: return 24
        case .pretendard17: return 20
        case .pretendard16(let weight):
            switch weight {
            case .bold: return 20
            case .semibold: return 22
            case .regular: return 24
            case .medium: return 20
            }
        case .pretendard15(let weight):
            switch weight {
            case .bold: return 18
            case .medium: return 18
            default: return self.size
            }
        case .pretendard14(let weight):
            switch weight {
            case .semibold: return 20
            case .medium: return 20
            default: return self.size
            }
        case .pretendard13(let weight):
            switch weight {
            case .bold: return 17
            case .semibold: return 20
            default: return self.size
            }
        case .pretendard12(let weight):
            switch weight {
            case .bold: return 14
            case .semibold: return 14
            default: return self.size
            }
        }
    }
}

extension Pretendard {
    static let bold: FontConvertible = .init(
        name: "Pretendard-Bold",
        family: "Pretendard",
        path: "Pretendard-Bold.otf"
    )

    static let semibold: FontConvertible = .init(
        name: "Pretendard-SemiBold",
        family: "Pretendard",
        path: "Pretendard-SemiBold.otf"
    )

    static let regular: FontConvertible = .init(
        name: "Pretendard-Regular",
        family: "Pretendard",
        path: "Pretendard-Regular.otf"
    )

    static let medium: FontConvertible = .init(
        name: "Pretendard-Medium",
        family: "Pretendard",
        path: "Pretendard-Medium.otf"
    )
}


extension Pretendard.Style: FontLineHeightConfigurable {
    public var font: UIFont {
        switch self {
        case .pretendard28(let weight),
                .pretendard22(let weight),
                .pretendard19(let weight),
                .pretendard18(let weight),
                .pretendard17(let weight),
                .pretendard16(let weight),
                .pretendard15(let weight),
                .pretendard14(let weight),
                .pretendard13(let weight),
                .pretendard12(let weight):
            return weight.fontConvertible.font(size: size)
        }
    }

    public var lineHeight: CGFloat {
        return lineHeightSize
    }
}
