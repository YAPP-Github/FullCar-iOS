//
//  FullCarNavigationBarModifier.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// FullCar에서 사용되는 NavigationBar입니다. NavigationBar는 화면 내용에 따라 타이틀과 아이콘이 변경됩니다.
public struct FullCarNavigationBarModifier<Title: View, Leading: View>: ViewModifier {
    @ViewBuilder private let title: Title
    @ViewBuilder private let leading: Leading

    private let navigationBarHeight: CGFloat
    private let leadingPadding: CGFloat = 20

    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                leadingView

                titleView
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
        .padding(.leading, leadingPadding)
    }

    private var titleView: some View {
        HStack {
            Spacer()
            
            title

            Spacer()
        }
    }
}

extension FullCarNavigationBarModifier {
    init(
        @ViewBuilder titleView: () -> Title = { EmptyView() } ,
        @ViewBuilder leadingView: () -> Leading = { EmptyView() },
        navigationBarHeight: CGFloat = 48
    ) {
        self.title = titleView()
        self.leading = leadingView()
        self.navigationBarHeight = navigationBarHeight
    }
}

public extension FullCarNavigationBarModifier where Title == NavigationTitle, Leading == NavigationBackButton {
    init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.init(
            titleView: {
                NavigationTitle(type: .title, title: title)
            },
            leadingView: {
                NavigationBackButton(action: action)
            }
        )
    }
}

public extension FullCarNavigationBarModifier where Title == NavigationTitle, Leading == EmptyView {
    init(
        title: String
    ) {
        self.init(
            titleView: {
                NavigationTitle(type: .title, title: title)
            },
            leadingView: { }
        )
    }
}

public extension FullCarNavigationBarModifier where Title == EmptyView, Leading == NavigationTitle {
    init(
        destination: String,
        navigationBarHeight: CGFloat = 61
    ) {
        self.init(
            titleView: { },
            leadingView: {
                NavigationTitle(type: .destination, title: destination)
            },
            navigationBarHeight: navigationBarHeight
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
            }
        }
    }
}
