//
//  FullCarNavigationBarModifier.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// FullCar에서 사용되는 NavigationBar입니다. NavigationBar는 화면 내용에 따라 타이틀과 아이콘이 변경됩니다.
public struct FCNavigationBarModifier<Leading: View, Center: View, Trailing: View>: ViewModifier {
    @ViewBuilder private let center: Center
    @ViewBuilder private let leading: Leading
    @ViewBuilder private let trailing: Trailing

    private let navigationBarHeight: NavigationBarHeight
    private let horizontalPadding: CGFloat = 20

    public func body(content: Content) -> some View {
        VStack {
            ZStack {
                leadingView

                centerView

                trailingView
            }
            .frame(height: navigationBarHeight.rawValue)
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

    private var centerView: some View {
        HStack {
            Spacer()
            
            center

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

public enum NavigationBarHeight: CGFloat {
    case _48 = 48
    case _61 = 61
}

public extension FCNavigationBarModifier {
    init(
        @ViewBuilder leadingView: () -> Leading = { EmptyView() },
        @ViewBuilder centerView: () -> Center = { EmptyView() } ,
        @ViewBuilder trailingView: () -> Trailing = { EmptyView() },
        barHeight: NavigationBarHeight
    ) {
        self.leading = leadingView()
        self.center = centerView()
        self.trailing = trailingView()
        self.navigationBarHeight = barHeight
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
                .navigationBarStyle(
                    leadingView: {
                        NavigationButton(icon: .back, action: { })
                    },
                    centerView: {
                        Text("회원가입")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: { }
                )

                //2. only title
                VStack {
                    Text("navigationBar - only title")
                }
                .navigationBarStyle(
                    leadingView: { },
                    centerView: {
                        Text("회원가입")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: { }
                )

                // 3. 목적지 leading
                VStack {
                    Text("navigationBar - destination leading")
                }
                .navigationBarStyle(
                    leadingView: {
                        Text("야놀자")
                            .font(.pretendard18(.bold))
                    },
                    centerView: { },
                    trailingView: {
                        Image(icon: .navigationLogo)
                    }
                )

                VStack {
                    Text("trailing Test")
                }
                .navigationBarStyle(
                    leadingView: {
                        NavigationButton(icon: .back, action: { })
                    },
                    centerView: {
                        Text("카풀 상세")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: {
                        NavigationButton(icon: .menu, action: { })
                    },
                    barHeight: ._61
                )
            }
        }
    }
}
