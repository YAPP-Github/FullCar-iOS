//
//  Badge.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 아이콘 + 라벨 조합의 배지입니다. 아이콘은 leading, none, trailing으로 위치를 선택할 수 있습니다.
public struct Badge: View {
    private let label: String
    private let badgeConfigurable: BadgeConfigurable
    private let iconConfigurable: IconConfigurable

    public var body: some View {
        HStack(spacing: badgeConfigurable.spacing) {
            if case let .leading(symbol) = iconConfigurable.location {
                icon(symbol: symbol)
            }

            Text(label)
                .font(pretendard: badgeConfigurable.font)
                .foregroundStyle(badgeConfigurable.style.dark)

            if case let .trailing(symbol) = iconConfigurable.location {
                icon(symbol: symbol)
            }
        }
        .padding(.horizontal, badgeConfigurable.horizontalPadding)
        .padding(.vertical, badgeConfigurable.verticalPadding)
        .background(badgeConfigurable.style.light)
        .cornerRadius(radius: badgeConfigurable.cornerRadius, corners: .allCorners)
    }

    @ViewBuilder
    private func icon(symbol: Icon.Symbol) -> some View {
        Image(icon: symbol)
            .renderingMode(.template)
            .resizable()
            .frame(iconSize: iconConfigurable.size)
            .foregroundStyle(iconConfigurable.color)
    }
}

public extension Badge {
    init(
        title: String,
        badgeConfigurable: BadgeConfigurable,
        iconConfigurable: IconConfigurable
    ) {
        self.label = title
        self.badgeConfigurable = badgeConfigurable
        self.iconConfigurable = iconConfigurable
    }
}

public extension Badge {
    /// 게시글의 상태값을 알려주는 배지입니다.
    init(
        postState: PostState
    ) {
        self.init(
            title: postState.rawValue,
            badgeConfigurable: .init(
                font: .bold12,
                style: postState.style
            ),
            iconConfigurable: .init(location: .none)
        )
    }

    /// 카풀 매칭의 상태값을 알려주는 배지입니다.
    init(
        matching: Matching
    ) {
        self.init(
            title: matching.rawValue,
            badgeConfigurable: .init(
                font: .bold12,
                style: matching.style
            ),
            iconConfigurable: .init(location: .none)
        )
    }

    /// 운전자의 정보를 알려주는 배지입니다.
    init(
        driver: Driver
    ) {
        switch driver {
        case .gender(let gender):
            self.init(
                title: gender.rawValue,
                badgeConfigurable: .init(
                    font: driver.font,
                    spacing: gender.spacing,
                    style: driver.style
                ),
                iconConfigurable: .init(
                    location: .leading(gender.icon),
                    size: driver.iconSize,
                    color: driver.iconColor
                )
            )
        case .mood(let mood):
            self.init(
                title: mood.rawValue,
                badgeConfigurable: .init(
                    font: driver.font,
                    spacing: mood.spacing,
                    style: driver.style
                ),
                iconConfigurable: .init(
                    location: .leading(mood.icon),
                    size: driver.iconSize,
                    color: driver.iconColor
                )
            )
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        VStack {
            Badge(postState: .recruite)
            Badge(postState: .request)
            Badge(postState: .close)
        }

        VStack {
            Badge(matching: .success)
            Badge(matching: .cancel)
        }

        VStack {
            Badge(driver: .gender(.female))
            Badge(driver: .gender(.male))
        }

        VStack {
            Badge(driver: .mood(.quiet))
            Badge(driver: .mood(.talk))

            Badge(
                title: "테스트",
                badgeConfigurable: .init(
                    font: .bold17, 
                    spacing: 5,
                    style: .primary_secondary
                ),
                iconConfigurable: .init(
                    location: .trailing(.user),
                    size: ._20,
                    color: .red
                )
            )
        }
    }
}
