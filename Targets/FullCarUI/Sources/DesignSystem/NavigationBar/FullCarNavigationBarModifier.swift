//
//  FullCarNavigationBarModifier.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// FullCar에서 사용되는 NavigationBar입니다. NavigationBar는 화면 내용에 따라 타이틀과 아이콘이 변경됩니다.
public struct FullCarNavigationBarModifier<Leading: View, Center: View, Trailing: View>: ViewModifier {
    @ViewBuilder private let title: Center
    @ViewBuilder private let leading: Leading
    @ViewBuilder private let trailing: Trailing

    private let navigationBarHeight: CGFloat
    private let horizontalPadding: CGFloat = 20

    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                leadingView

                titleView

                trailingView
            }
            .frame(height: navigationBarHeight)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .border(width: 1, edges: [.bottom], color: .gray30)

            content

            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var leadingView: some View {
        HStack {
            leading

            Spacer()
        }
        .padding(.leading, horizontalPadding)
    }

    private var titleView: some View {
        HStack {
            Spacer()
            
            title

            Spacer()
        }
    }

    private var trailingView: some View {
        HStack {
            Spacer()

            trailing
        }
        .padding(.trailing, horizontalPadding)
    }
}

public extension FullCarNavigationBarModifier {
    init(
        @ViewBuilder leadingView: () -> Leading = { EmptyView() },
        @ViewBuilder centerView: () -> Center = { EmptyView() } ,
        @ViewBuilder trailingView: () -> Trailing = { EmptyView() },
        barHeight: CGFloat = 48
    ) {
        self.leading = leadingView()
        self.title = centerView()
        self.trailing = trailingView()
        self.navigationBarHeight = barHeight
    }
}

public extension FullCarNavigationBarModifier where Center == NavigationTitle, Leading == NavigationButton, Trailing == EmptyView {
    init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.init(
            leadingView: {
                NavigationButton(symbol: .back, action: action)
            },
            centerView: { NavigationTitle(type: .title, title: title) },
            trailingView: { }
        )
    }
}

public extension FullCarNavigationBarModifier where Center == NavigationTitle, Leading == EmptyView, Trailing == EmptyView {
    init(
        title: String
    ) {
        self.init(
            leadingView: { }, 
            centerView: { NavigationTitle(type: .title, title: title) },
            trailingView: { }
        )
    }
}

public extension FullCarNavigationBarModifier where Center == EmptyView, Leading == NavigationTitle, Trailing == EmptyView {
    init(
        destination: String,
        navigationBarHeight: CGFloat = 61
    ) {
        self.init(
            leadingView: { NavigationTitle(type: .destination, title: destination) },
            centerView: { },
            trailingView: { },
            barHeight: navigationBarHeight
        )
    }
}

struct FullCarNavigationBarPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VStack {
                //1. back button leading
                VStack {
                    Text("navigationBar - back button leading")
                }
                .fullCarNavigationBar(title: "회원가입", action: {})

                //2. only title
                VStack {
                    Text("navigationBar - only title")
                }
                .fullCarNavigationBar(title: "회원가입")

                // 3. 목적지 leading
                VStack {
                    Text("navigationBar - destination leading")
                }
                .fullCarNavigationBar(destination: "네이버")

                VStack {
                    Text("trailing Test")
                }
                .fullCarNavigationBar(
                    leadingView: {
                        naviLeadingView
                    },
                    centerView: { EmptyView() },
                    trailingView: {
                        naviTrailingView
                            .background(.red)
                    },
                    barHeight: 61
                )
            }
        }
    }

    @ViewBuilder
    static var naviLeadingView: some View {
        Icon.image(type: .car)
            .frame(width: 28, height: 28)
    }

    @ViewBuilder
    static var naviTrailingView: some View {
        Icon.image(type: .car)
            .frame(width: 28, height: 28)
    }
}
