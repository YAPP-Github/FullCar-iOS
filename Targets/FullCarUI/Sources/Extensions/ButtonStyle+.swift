//
//  ButtonStyle+.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

extension ButtonStyle where Self == FullCarButtonStyle {

    /// 계층 구조가 가장 높은 행동을 유도하는 Button에 한정해 사용합니다.
    public static var fullCar: FullCarButtonStyle {
        FullCarButtonStyle()
    }

    /// Basic Filter Chips는 Selected/Unselected에 따라 Default, Active 상태로 분류됩니다. Selected는 Active된 상태로 간주됩니다.
    public static var chip: ChipButtonStyle {
        ChipButtonStyle()
    }
}
