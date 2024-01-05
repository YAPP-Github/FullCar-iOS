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
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(pretendard: .body1)
            .padding(.vertical, Constants.verticalPadding)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Colors.text)
            .background(isEnabled ? Colors.background : Colors.disableBackground)
            .cornerRadius(radius: Constants.radius, corners: .allCorners)
    }
}

extension FullCarButtonStyle {
    enum Constants {
        static let verticalPadding: CGFloat = 17
        static let radius: CGFloat = 8
    }

    enum Colors {
        static let text: Color = .white
        static let background: Color = .fullCar_primary
        static let disableBackground: Color = .gray30
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
