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
    /// TextField가 선택되지 않았고 , error도 없는 상태
    case `default`
    case focus
    case error(String)

    public var borderColor: Color {
        switch self {
        case .default: return .gray30
        case .focus: return .fullCar_primary
        case .error: return .red100
        }
    }
}
