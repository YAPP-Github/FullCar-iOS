//
//  Icon+Custom.swift
//  FullCarUI
//
//  Created by Sunny on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public extension View {
    /// Icon의 frame을 조절하는 메서드입니다.
    func frame(iconSize: FCIcon.Size) -> some View {
        self.frame(width: iconSize.rawValue, height: iconSize.rawValue)
    }
}

public extension Image {
    init(icon: FCIcon.Symbol) {
        if !icon.name.isEmpty {
            self.init(icon.name, bundle: .module)
        } else {
            self.init(systemName: icon.systemName)
        }
    }
}
