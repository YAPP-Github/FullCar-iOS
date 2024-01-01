//
//  InputState.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// TextField의 상태값을 나타내는 타입
public enum InputState {
    case normal
    case focus
    case error(String)

    public var borderColor: Color {
        switch self {
        case .normal: return Color.gray30
        case .focus: return Color.fullCar_primary
        case .error: return Color.red100
        }
    }
}
