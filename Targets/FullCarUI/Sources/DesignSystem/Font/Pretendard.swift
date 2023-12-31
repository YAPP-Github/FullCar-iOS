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
        /// 22, bold
        case heading1
        /// 18, bold
        case heading2
        /// 18, semibold
        case heading3

        /// 17, bold
        case body1
        /// 17, semibold
        case body2
        /// 16, bold
        case body3
        /// 16, semibold
        case body4
        /// 16, regular
        case body5
        /// 15, bold
        case body6
        /// 15, medium
        case body7

        /// 14, semibold
        case caption1
        /// 14, medium
        case caption2
        /// 13, bold
        case caption3
        /// 13, medium
        case caption4
        /// 12, bold
        case caption5
        /// 12, semibold
        case caption6

        var weight: FontConvertible {
            switch self {
            case .heading1: return Pretendard.bold
            case .heading2: return Pretendard.bold
            case .heading3: return Pretendard.semiBold

            case .body1: return Pretendard.bold
            case .body2: return Pretendard.semiBold
            case .body3: return Pretendard.bold
            case .body4: return Pretendard.semiBold
            case .body5: return Pretendard.regular
            case .body6: return Pretendard.bold
            case .body7: return Pretendard.medium

            case .caption1: return Pretendard.semiBold
            case .caption2: return Pretendard.medium
            case .caption3: return Pretendard.bold
            case .caption4: return Pretendard.medium
            case .caption5: return Pretendard.bold
            case .caption6: return Pretendard.semiBold
            }
        }

        var size: CGFloat {
            switch self {
            case .heading1: return 22
            case .heading2: return 18
            case .heading3: return 18

            case .body1: return 17
            case .body2: return 17
            case .body3: return 16
            case .body4: return 16
            case .body5: return 16
            case .body6: return 15
            case .body7: return 15

            case .caption1: return 14
            case .caption2: return 14
            case .caption3: return 13
            case .caption4: return 13
            case .caption5: return 12
            case .caption6: return 12
            }
        }

        var lineHeightSize: CGFloat {
            return self.size + 12
        }
    }
}

extension Pretendard {
    public static let bold = FontConvertible(
        name: "Pretendard-Bold",
        family: "Pretendard",
        path: "Pretendard-Bold.otf"
    )
    public static let medium = FontConvertible(
        name: "Pretendard-Medium",
        family: "Pretendard",
        path: "Pretendard-Medium.otf"
    )
    public static let regular = FontConvertible(
        name: "Pretendard-Regular",
        family: "Pretendard",
        path: "Pretendard-Regular.otf"
    )
    public static let semiBold = FontConvertible(
        name: "Pretendard-SemiBold",
        family: "Pretendard",
        path: "Pretendard-SemiBold.otf"
    )
}

extension Pretendard.Style: FontLineHeightConfigurable {
    public var font: UIFont {
        return self.weight.font(size: self.size)
    }

    public var lineHeight: CGFloat {
        return self.lineHeightSize
    }
}
