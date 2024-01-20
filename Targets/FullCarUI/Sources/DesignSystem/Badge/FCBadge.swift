//
//  FCBadge.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 아이콘 + 라벨 조합의 배지입니다. 아이콘은 leading, none, trailing으로 위치를 선택할 수 있습니다.
public struct FCBadge: View {
    private let label: String
    private let badgeConfigurable: BadgeConfigurable
    private let iconConfigurable: IconConfigurable

    public var body: some View {
        HStack(spacing: badgeConfigurable.spacing) {
            if case let .leading(symbol) = iconConfigurable.location {
                iconView(symbol)
            }

            Text(label)
                .font(badgeConfigurable.font)
                .foregroundStyle(badgeConfigurable.style.dark)

            if case let .trailing(symbol) = iconConfigurable.location {
                iconView(symbol)
            }
        }
        .padding(.horizontal, badgeConfigurable.horizontalPadding)
        .padding(.vertical, badgeConfigurable.verticalPadding)
        .background(badgeConfigurable.style.light)
        .cornerRadius(radius: badgeConfigurable.cornerRadius, corners: .allCorners)
    }

    @ViewBuilder
    private func iconView(_ symbol: FCIcon.Symbol) -> some View {
        Image(icon: symbol)
            .renderingMode(.template)
            .resizable()
            .frame(iconSize: iconConfigurable.size)
            .foregroundStyle(iconConfigurable.color)
    }
}

public extension FCBadge {
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

public extension FCBadge {
    /// 게시글의 상태값을 알려주는 배지입니다.
    init(
        postState: PostState
    ) {
        self.init(
            title: postState.rawValue,
            badgeConfigurable: .init(
                font: .pretendard12(.bold),
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
                font: .pretendard12(.bold),
                style: matching.style
            ),
            iconConfigurable: .init(location: .none)
        )
    }

    /// 운전자의 성별 정보를 알려주는 배지입니다.
    init(
        gender: Driver.Gender
    ) {
        self.init(
            title: gender.rawValue,
            badgeConfigurable: .init(
                font: Driver.BadgeStyle.font,
                spacing: gender.spacing,
                style: Driver.BadgeStyle.style
            ),
            iconConfigurable: .init(
                location: .leading(gender.icon),
                size: Driver.BadgeStyle.iconSize,
                color: Driver.BadgeStyle.iconColor
            )
        )
    }

    init(
        mood: Driver.Mood
    ) {
        self.init(
            title: mood.rawValue,
            badgeConfigurable: .init(
                font: Driver.BadgeStyle.font,
                spacing: mood.spacing,
                style: Driver.BadgeStyle.style
            ),
            iconConfigurable: .init(
                location: .leading(mood.icon),
                size: Driver.BadgeStyle.iconSize,
                color: Driver.BadgeStyle.iconColor
            )
        )
    }
}

#Preview {
    VStack(spacing: 30) {
        VStack {
            FCBadge(postState: .recruite)
            FCBadge(postState: .request)
            FCBadge(postState: .close)
        }

        VStack {
            FCBadge(matching: .success)
            FCBadge(matching: .cancel)
        }

        VStack {
            FCBadge(gender: .female)
            FCBadge(gender: .male)
        }

        VStack {
            FCBadge(mood: .quiet)
            FCBadge(mood: .talk)

            FCBadge(
                title: "테스트",
                badgeConfigurable: .init(
                    font: .pretendard17(.bold), 
                    spacing: 5,
                    style: .palette(.primary_secondary)
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
