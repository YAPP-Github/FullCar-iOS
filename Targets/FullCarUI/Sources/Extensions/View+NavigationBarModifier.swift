//
//  View+NavigationBarModifier.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public extension View {
    /// 화면 title + back button
    func fullCarNavigationBar(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        modifier(FullCarNavigationBarModifier(title: title, action: action))
    }

    /// 화면 title
    func fullCarNavigationBar(
        title: String
    ) -> some View {
        modifier(FullCarNavigationBarModifier(title: title))
    }

    /// 자동차 아이콘 + 도착지 title
    func fullCarNavigationBar(
        destination: String
    ) -> some View {
        modifier(FullCarNavigationBarModifier(destination: destination))
    }

    func fullCarNavigationBar<Leading: View, Center: View, Trailing: View>(
        @ViewBuilder leadingView: () -> Leading,
        @ViewBuilder centerView: () -> Center,
        @ViewBuilder trailingView: () -> Trailing,
        barHeight: CGFloat
    ) -> some View {
        modifier(
            FullCarNavigationBarModifier(
                leadingView: leadingView,
                centerView: centerView,
                trailingView: trailingView,
                barHeight: barHeight
            )
        )
    }
}
