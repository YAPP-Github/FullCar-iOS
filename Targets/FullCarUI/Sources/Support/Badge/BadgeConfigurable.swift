//
//  BadgeConfigurable.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// Badge의 구성 가능한 특성을 나타낸 타입입니다.
public struct BadgeConfigurable {
    var font: Pretendard.Style
    var spacing: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let cornerRadius: CGFloat
    let style: ColorStyle

    public init(
        font: Pretendard.Style,
        spacing: CGFloat = 0,
        horizontalPadding: CGFloat = 8,
        verticalPadding: CGFloat = 5,
        cornerRadius: CGFloat = 3,
        style: ColorStyle
    ) {
        self.font = font
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.style = style
    }
}

/// Badge 아이콘의 구성 가능한 특성을 나타낸 타입입니다.
public struct IconConfigurable {
    let location: Location
    let size: FCIcon.Size
    let color: Color

    public enum Location {
        case leading(FCIcon.Symbol)
        case trailing(FCIcon.Symbol)
        case none
    }

    public init(
        location: Location,
        size: FCIcon.Size = ._0,
        color: Color = .clear
    ) {
        self.location = location
        self.size = size
        self.color = color
    }
}
