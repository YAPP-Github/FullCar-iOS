//
//  Button.swift
//  FullCarUI
//
//  Created by Sunny on 12/31/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 계층 구조가 가장 높은 행동을 유도하는 Button에 한정해 사용합니다.
///
/// ### 사용 방법
///
/// ```swift
/// Button(action: {}, label: { Text("Button") })
///    .buttonStyle(FullCarButtonStyle())
/// ```
public struct FullCarButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    private let labelColor = Color.white
    private let backgroundActiveColor = Color.fullCar_primary
    private let backgroundInactiveColor = Color.gray30

    private let verticalPadding: CGFloat = 17
    private let radius: CGFloat = 8

    public init() { }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(pretendard: .body1)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity)
            .foregroundStyle(labelColor)
            .background(isEnabled ? backgroundActiveColor : backgroundInactiveColor)
            .cornerRadius(radius: radius, corners: .allCorners)
    }
}
