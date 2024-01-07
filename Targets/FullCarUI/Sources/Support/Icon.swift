//
//  Icon.Symbol.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct Icon { 
    public static func image(type: Icon.Symbol) -> Image? {
        return type.image
    }
}

extension Icon {
    public enum Symbol {
        /// Badge
        case female
        /// Badge
        case male
        /// Badge
        case quite
        /// Badge
        case talk
        /// textField check, Message - .information
        case check
        /// navigationBar - backButton
        case back
        /// navigationBar - destination
        case car

        public var image: Image? {
            if let systemName = systemName {
                return Image(systemName: systemName)
            } else if let name = name {
                return Image(name)
            } else {
                return nil
            }
        }

        private var name: String? {
            switch self {
                // 추후 이미지 추가 예정
            case .female: return "square.and.arrow.up.circle"
            case .male: return "square.and.arrow.up.circle"
            case .quite: return "square.and.arrow.up.circle"
            case .talk: return "square.and.arrow.up.circle"
            default: return nil
            }
        }

        private var systemName: String? {
            switch self {
            case .female: return "person.fill"
            case .male: return "person.fill"
            case .quite: return "square.and.arrow.up.circle"
            case .talk: return "square.and.arrow.up.circle"
            case .check: return "checkmark.circle.fill"
            case .back: return "chevron.left"
            case .car: return "car.fill"
            }
        }
    }
}
