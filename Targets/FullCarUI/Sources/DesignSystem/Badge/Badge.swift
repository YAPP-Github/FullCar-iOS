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
        HStack(spacing: configurable.spacing) {
            leadingIcon

            label
                .font(pretendard: configurable.font)
                .foregroundStyle(style.dark)

            trailingIcon
        }
        .padding(.horizontal, configurable.horizontalPadding)
        .padding(.vertical, configurable.verticalPadding)
        .background(style.light)
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
        postState: PostState
    ) {
        self.init(
            title: postState.rawValue,
            configurable: postState.configurable,
            style: postState.style
        )
    }

    /// 카풀 매칭의 상태값을 알려주는 배지입니다.
    init(
        matching: Matching
    ) {
        self.init(
            title: matching.rawValue,
            configurable: matching.configurable,
            style: matching.style
        )
    }
}

public extension Badge where Label == Text, LeadingIcon == Icon, TrailingIcon == EmptyView {
    /// 운전자의 정보를 알려주는 배지입니다.
    init(
        driver: Driver
    ) {
        switch driver {
        case .gender(let gender):
            self.init(
                title: gender.rawValue,
                configurable: gender.configurable,
                style: gender.style,
                leading: { Icon(configuration: gender.iconConfiguration) }
                )
        case .mood(let mood):
            self.init(
                title: mood.rawValue,
                configurable: mood.configurable,
                style: mood.style,
                leading: { Icon(configuration: mood.iconConfiguration) }
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
                configurable: .init(font: .semibold17, spacing: 5),
                style: .palette(.red),
                leading: {
                    Icon.image(type: .car)?
                        .frame(height: 20)
                },
                trailing: {
                    Icon.image(type: .female)
                }
            )
        }
    }
}

