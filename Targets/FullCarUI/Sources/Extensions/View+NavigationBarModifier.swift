//
//  View+NavigationBarModifier.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public extension View {
    func navigationBarStyle<Leading: View, Center: View, Trailing: View>(
        @ViewBuilder leadingView: () -> Leading,
        @ViewBuilder centerView: () -> Center,
        @ViewBuilder trailingView: () -> Trailing,
        barHeight: NavigationBarHeight = ._48
    ) -> some View {
        modifier(
            FCNavigationBarModifier(
                leadingView: leadingView,
                centerView: centerView,
                trailingView: trailingView,
                barHeight: barHeight
            )
        )
    }
}
