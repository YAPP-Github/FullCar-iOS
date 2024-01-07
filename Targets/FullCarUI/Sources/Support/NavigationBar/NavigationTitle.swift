//
//  NavigationTitle.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// NavigationBar에서 사용하는 title view 입니다.
public struct NavigationTitle: View {
    private let type: NavigationTitleType
    private let title: String

    public init(
        type: NavigationTitleType,
        title: String
    ) {
        self.type = type
        self.title = title
    }

    public var body: some View {
        switch type {
        case .title:
            Text(title)
                .font(pretendard: .bold18)
        case .destination:
            HStack(spacing: Constants.destinationSpacing) {
                Icon.image(type: .car)
                    .frame(width: Constants.destinationIconSize)

                Text(title)
                    .font(pretendard: .bold18)
            }
        }
    }
}

public extension NavigationTitle {
    /// NavigationTitleType은 현재 화면의 제목을 나타내는 title과 홈 화면의 navigationBar에서 사용하는 목적지 title로 구성되어있습니다.
    enum NavigationTitleType {
        case title
        case destination
    }

    enum Constants {
        static let destinationSpacing: CGFloat = 6
        static let destinationIconSize: CGFloat = 28
    }
}
