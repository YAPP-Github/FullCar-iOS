//
//  ButtonStyle+.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

extension ButtonStyle where Self == FCarButtonStyle {
    /// 폰트, 색상, padding 등을 커스텀 할 수 있는 버튼입니다. 버튼의 색상은 ColorStyle을 사용합니다.
    public static func fullCar(
        font: Pretendard.Style = .pretendard17(.bold),
        horizontalPadding: CGFloat = 0,
        verticalPadding: CGFloat = 17,
        radius: CGFloat = 8,
        style: ColorStyle
    ) -> FCarButtonStyle {
        FCarButtonStyle(
            font: font,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            radius: radius,
            colorStyle: style
        )
    }

    /// Basic Filter Chips는 Selected/Unselected에 따라 Default, Active 상태로 분류됩니다. Selected는 Active된 상태로 간주됩니다.
    public static func chip(_ isSelected: Bool) -> ChipButtonStyle {
        ChipButtonStyle(isSelected: isSelected)
    }
}
