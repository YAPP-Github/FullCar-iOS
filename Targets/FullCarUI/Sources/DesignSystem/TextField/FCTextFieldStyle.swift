//
//  FCTextFieldStyle.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct FCTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    @Binding private var state: InputState

    private let accessory: AccessoryType
    private let padding: CGFloat
    private let backgroundColor: Color
    private let cornerRadius: CGFloat

    public typealias Configuration = TextField<Self._Label>

    public func _body(configuration: Configuration) -> some View {
        HStack {
            configuration
                .font(.pretendard16_19(.semibold))
                .focused($isFocused)
                // 에러 상태일 땐, focus상태여도 error상태 그대로 유지
                .onChange(of: isFocused) { oldValue, newValue in
                    if case .error = state { return }
                    state = newValue ? .focus : .default
                }

            if case .check(let isChecked) = accessory, isChecked.wrappedValue {
                Image(icon: .check)
                    .resizable()
                    .frame(iconSize: ._24)
                    .foregroundStyle(Color.green100)
            }

            if case .won = accessory {
                Text("원")
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(Color.gray45)
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(state.borderColor, lineWidth: 1)
        )
    }
}

public extension FCTextFieldStyle {
    init(
        state: Binding<InputState>,
        accessoryType: AccessoryType,
        padding: CGFloat,
        backgroundColor: Color,
        radius: CGFloat
    ) {
        self._state = state
        self.accessory = accessoryType
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = radius
    }

    enum AccessoryType {
        case check(Binding<Bool>)
        case won
        case none
    }
}
