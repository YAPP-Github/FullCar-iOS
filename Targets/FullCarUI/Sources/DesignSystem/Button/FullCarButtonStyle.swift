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

    private let textColor = Color.white

    private let verticalPadding: CGFloat = 17
    private let radius: CGFloat = 8

    public init() { }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(pretendard: .body1)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity)
            .foregroundStyle(textColor)
            .background(isEnabled ? Color.fullCar_primary : Color.gray30)
            .cornerRadius(radius: radius, corners: .allCorners)
    }
}

struct FullCarButtonStylePreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button(action: {}, label: {
                Text("다음")
            })
            .buttonStyle(.fullCar)

            Button(action: {}, label: {
                Text("다음")
            })
            .buttonStyle(.fullCar)
            .disabled(true)
        }
    }
}
