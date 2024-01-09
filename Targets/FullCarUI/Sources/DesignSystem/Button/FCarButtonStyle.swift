//
//  FCarButtonStyle.swift
//  FullCarUI
//
//  Created by Sunny on 12/31/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct FCarButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    private let font: Pretendard.Style
    private let verticalPadding: CGFloat
    private let horizontalPadding: CGFloat
    private let cornerRadius: CGFloat
    private let colorStyle: ColorStyle

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(radius: cornerRadius, corners: .allCorners)
    }
}

public extension FCarButtonStyle {
    init(
        font: Pretendard.Style,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        radius: CGFloat,
        colorStyle: ColorStyle
    ) {
        self.font = font
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = radius
        self.colorStyle = colorStyle
    }

    private var foregroundColor: Color {
        if colorStyle == .palette(.primary_white) {
            switch isEnabled {
            case true: return ColorStyle.palette(.primary_white).light
            case false: return ColorStyle.palette(.gray30).light
            }
        } else {
            return colorStyle.dark
        }
    }

    private var backgroundColor: Color {
        if colorStyle == .palette(.primary_white) {
            switch isEnabled {
            case true: return ColorStyle.palette(.primary_white).dark
            case false: return ColorStyle.palette(.gray30).dark
            }
        } else {
            return colorStyle.light
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Button(action: {}, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.fullCar(style: .palette(.primary_white)))

        Button(action: {}, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.fullCar(style: .palette(.primary_white)))
        .disabled(true)

        Button(action: {}, label: {
            Text("인증메일 발송")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.fullCar(style: .palette(.primary_white)))
        .disabled(true)

        Button(action: {}, label: {
            Text("요청거절")
        })
        .buttonStyle(.fullCar(
            horizontalPadding: 22,
            style: .palette(.gray60)
        ))
        .disabled(true)

        Button(action: {}, label: {
            Text("요청승인")
        })
        .buttonStyle(.fullCar(
            horizontalPadding: 70,
            style: .palette(.primary_white)
        ))

        Button(action: {}, label: {
            Text("검색")
        })
        .buttonStyle(.fullCar(
            font: .pretendard16(.semibold),
            horizontalPadding: 14,
            verticalPadding: 15,
            style: .palette(.primary_secondary)
        ))

        Button(action: {}, label: {
            Text("검색")
        })
        .buttonStyle(.fullCar(
            font: .pretendard16(.semibold),
            horizontalPadding: 14,
            verticalPadding: 15,
            style: .init(dark: .red100, light: .red50)
        ))
    }
}
