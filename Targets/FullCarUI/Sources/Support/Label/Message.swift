//
//  Message.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// icon과 text가 결합된 타입
public enum Message {
    case information(String, icon: Icon.Symbol? = .check)
    case error(String, icon: Icon.Symbol? = nil)

    public var fontColor: Color {
        switch self {
        case .information: return .fullCar_primary
        case .error: return .red100
        }
    }

    public var description: String {
        switch self {
        case .information(let text, _), .error(let text, _):
            return text
        }
    }

    public var icon: Icon.Symbol? {
        switch self {
        case .information(_, let icon), .error(_, let icon):
            return icon
        }
    }
}
