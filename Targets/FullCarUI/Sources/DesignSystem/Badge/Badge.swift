//
//  Badge.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 아이콘 + 라벨 + 아이콘 조합의 배지입니다.
public struct Badge<LeadingIcon: View, Label: View, TrailingIcon: View>: View {
    private let configurable: BadgeConfigurable
    private let style: ColorStyle

    @ViewBuilder private let leadingIcon: LeadingIcon
    @ViewBuilder private let label: Label
    @ViewBuilder private let trailingIcon: TrailingIcon

    public var body: some View {
        HStack(spacing: configurable.iconSpacing) {
            leadingIcon
                .frame(width: configurable.iconSize, height: configurable.iconSize)

            label
                .font(pretendard: configurable.font)
                .foregroundStyle(style.main)

            trailingIcon
                .frame(width: configurable.iconSize, height: configurable.iconSize)
        }
        .padding(.horizontal, configurable.horizontalPadding)
        .padding(.vertical, configurable.verticalPadding)
        .background(style.background)
        .cornerRadius(radius: configurable.cornerRadius, corners: .allCorners)
    }
}

extension Badge {
    private init(
        configurable: BadgeConfigurable,
        style: ColorStyle,
        @ViewBuilder leading: () -> LeadingIcon = { EmptyView() },
        @ViewBuilder label: () -> Label = { EmptyView() },
        @ViewBuilder trailing: () -> TrailingIcon = { EmptyView() }
    ) {
        self.configurable = configurable
        self.style = style
        self.leadingIcon = leading()
        self.label = label()
        self.trailingIcon = trailing()
    }
}

public extension Badge where Label == Text {
    init(
        title: String,
        configurable: BadgeConfigurable,
        style: ColorStyle,
        @ViewBuilder leading: () -> LeadingIcon = { EmptyView() },
        @ViewBuilder trailing: () -> TrailingIcon = { EmptyView() }
    ) {
        self.configurable = configurable
        self.style = style
        self.leadingIcon = leading()
        self.label = { Text(title) }()
        self.trailingIcon = trailing()
    }
}

public extension Badge where Label == Text, LeadingIcon == EmptyView, TrailingIcon == EmptyView {
    /// 게시글의 상태값을 알려주는 배지입니다.
    init(
        _ postState: BadgeType.PostState
    ) {
        self.init(
            title: postState.rawValue,
            configurable: postState.configurable,
            style: postState.style
        )
    }

    /// 카풀 매칭의 상태값을 알려주는 배지입니다.
    init(
        _ matching: BadgeType.Matching
    ) {
        self.init(
            title: matching.rawValue,
            configurable: matching.configurable,
            style: matching.style
        )
    }
}

public extension Badge where Label == Text, LeadingIcon == Image?, TrailingIcon == EmptyView {
    /// 운전자의 정보를 알려주는 배지입니다.
    init(
        _ driver: BadgeType.Driver
    ) {
        self.init(
            title: driver.rawValue,
            configurable: driver.configurable,
            style: driver.style,
            leading: { driver.icon?.resizable() }
        )
    }
}

#Preview {
    VStack(spacing: 30) {
        VStack {
            Badge(.recruite)
            Badge(.request)
            Badge(.close)
        }

        VStack {
            Badge(.success)
            Badge(.cancel)
        }

        VStack {
            Badge(.female)
            Badge(.male)
        }

        VStack {
            Badge(.quiet)
            Badge(.talk)

            Badge(
                title: "테스트",
                configurable: .init(font: .body2, iconSpacing: 5), 
                style: .palette(.red),
                leading: {
                    Icon.image(type: .car)?
                        .resizable()
                },
                trailing: {
                    Icon.image(type: .female)
                }
            )
        }
    }
}

