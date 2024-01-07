//
//  NavigationBackButton.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// NavigationBar에서 사용하는 back button 입니다.
public struct NavigationBackButton: View {
    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            Icon.image(type: .back)
                .frame(width: Constants.backIconSize)
                .foregroundStyle(Color.black80)
        })
    }
}

extension NavigationBackButton {
    enum Constants {
        static let backIconSize: CGFloat = 24
    }
}
