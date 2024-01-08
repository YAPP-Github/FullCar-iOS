//
//  Badge.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 아이콘 + 라벨 + 아이콘 조합의 배지입니다.
public struct Badge<LeadingIcon: View, TrailingIcon: View>: View {
    @ViewBuilder private let leadingIcon: LeadingIcon
    @ViewBuilder private let trailingIcon: TrailingIcon

    private let title: String
    private let badgeConfigurable: BadgeConfigurable
    private let iconSize: Icon.Size
    private let iconColor: Color
    private let style: ColorStyle

    public var body: some View {
        HStack(spacing: badgeConfigurable.spacing) {
            leadingIcon
                .frame(iconSize: iconSize)
                .foregroundStyle(iconColor)

            Text(title)
                .font(pretendard: badgeConfigurable.font)
                .foregroundStyle(style.dark)

            trailingIcon
                .frame(iconSize: iconSize)
                .foregroundStyle(iconColor)
        }
        .padding(.horizontal, badgeConfigurable.horizontalPadding)
        .padding(.vertical, badgeConfigurable.verticalPadding)
        .background(style.light)
        .cornerRadius(radius: badgeConfigurable.cornerRadius, corners: .allCorners)
    }
}

public extension Badge {
    init(
        @ViewBuilder leading: () -> LeadingIcon = { EmptyView() },
        @ViewBuilder trailing: () -> TrailingIcon = { EmptyView() },
        title: String,
        badgeConfigurable: BadgeConfigurable,
        iconSize: Icon.Size = ._0,
        iconColor: Color = .clear,
        style: ColorStyle
    ) {
        self.leadingIcon = leading()
        self.trailingIcon = trailing()
        self.title = title
        self.badgeConfigurable = badgeConfigurable
        self.iconSize = iconSize
        self.iconColor = iconColor
        self.style = style
    }
}

public extension Badge where LeadingIcon == EmptyView, TrailingIcon == EmptyView {
    /// 게시글의 상태값을 알려주는 배지입니다.
    init(
        postState: PostState
    ) {
        self.init(
            title: postState.rawValue,
            badgeConfigurable: postState.badgeConfigurable,
            style: postState.style
        )
    }

    /// 카풀 매칭의 상태값을 알려주는 배지입니다.
    init(
        matching: Matching
    ) {
        self.init(
            title: matching.rawValue,
            badgeConfigurable: matching.badgeConfigurable,
            style: matching.style
        )
    }
}

public extension Badge where LeadingIcon == Image, TrailingIcon == EmptyView {
    /// 운전자의 정보를 알려주는 배지입니다.
    init(
        driver: Driver
    ) {
        switch driver {
        case .gender(let gender):
            self.init(
                leading: {
                    Image(icon: gender.icon)
                        .resizable()
                        .renderingMode(.template)
                }, 
                title: gender.rawValue,
                badgeConfigurable: gender.badgeConfigurable,
                iconSize: driver.iconSize,
                iconColor: driver.iconColor,
                style: gender.style
            )
        case .mood(let mood):
            self.init(
                leading: {
                    Image(icon: mood.icon)
                        .resizable()
                        .renderingMode(.template)
                }, 
                title: mood.rawValue,
                badgeConfigurable: mood.badgeConfigurable,
                iconSize: driver.iconSize,
                iconColor: driver.iconColor,
                style: mood.style
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
                leading: {
                    Image(icon: .user)
                        .resizable()
                },
                trailing: { }, 
                title: "테스트",
                badgeConfigurable: .init(font: .bold17, spacing: 5),
                iconSize: ._20,
                style: .palette(.red)
            )
        }
    }
}

