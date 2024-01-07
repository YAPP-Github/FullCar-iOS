//
//  FullCarButtonStyle.swift
//  FullCarUI
//
//  Created by Sunny on 12/31/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct FullCarButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    private let font: Pretendard.Style
    private let verticalPadding: CGFloat
    private let horizontalPadding: CGFloat
    private let cornerRadius: CGFloat
    private let colorStyle: ColorStyle.Palette

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(pretendard: font)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(radius: cornerRadius, corners: .allCorners)
    }

    private var foregroundColor: Color {
        if colorStyle == ColorStyle.Palette.primary_white {
            switch isEnabled {
            case true: return ColorStyle.palette(.primary_white).light
            case false: return ColorStyle.palette(.gray30).light
            }
        } else {
            return ColorStyle.palette(colorStyle).dark
        }
    }

    private var backgroundColor: Color {
        if colorStyle == ColorStyle.Palette.primary_white {
            switch isEnabled {
            case true: return ColorStyle.palette(.primary_white).dark
            case false: return ColorStyle.palette(.gray30).dark
            }
        } else {
            return ColorStyle.palette(colorStyle).light
        }
    }
}

public extension FullCarButtonStyle {
    init(
        font: Pretendard.Style,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        radius: CGFloat,
        colorStyle: ColorStyle.Palette
    ) {
        self.font = font
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = radius
        self.colorStyle = colorStyle
    }
}

#Preview {
    VStack(spacing: 20) {
        Button(action: {}, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.fullCar(style: .primary_white))

        Button(action: {}, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.fullCar(style: .primary_white))
        .disabled(true)

        Button(action: {}, label: {
            Text("인증메일 발송")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.fullCar(style: .primary_white))
        .disabled(true)

        Button(action: {}, label: {
            Text("요청거절")
        })
        .buttonStyle(.fullCar(
            horizontalPadding: 22,
            style: .gray60
        ))
        .disabled(true)

        Button(action: {}, label: {
            Text("요청승인")
        })
        .buttonStyle(.fullCar(
            horizontalPadding: 70,
            style: .primary_white
        ))

        Button(action: {}, label: {
            Text("검색")
        })
        .buttonStyle(.fullCar(
            font: .semibold16,
            horizontalPadding: 14,
            verticalPadding: 15,
            style: .primary_secondary
        ))
    }
}
