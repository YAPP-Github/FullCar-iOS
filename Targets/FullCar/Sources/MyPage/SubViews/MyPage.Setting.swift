//
//  MyPage.Setting.swift
//  FullCar
//
//  Created by Sunny on 2/10/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

extension MyPage.Setting {
    @MainActor
    struct BodyView: View {
        @Environment(\.dismiss) var dismiss
        @Bindable var viewModel: MyPage.ViewModel

        var body: some View {
            bodyView
                .navigationBarStyle(
                    leadingView: {
                        NavigationButton(icon: .back, action: { dismiss() })
                    },
                    centerView: {
                        Text("설정")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: { }
                )
        }

        private var bodyView: some View {
            VStack(spacing: .zero) {
                buttonItem(text: "로그아웃", action: {})
                buttonItem(text: "탈퇴", action: {})
            }
        }

        private func buttonItem(
            text: String,
            action: @escaping () -> Void
        ) -> some View {
            Button(action: action, label: {
                HStack(spacing: .zero) {
                    Text(text)
                        .font(.pretendard16(.medium))
                        .foregroundStyle(Color.black80)

                    Spacer()

                    Image(icon: .chevron_right)
                        .frame(iconSize: ._20)
                        .foregroundStyle(Color.gray60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 18)
            })
        }
    }
}

#if DEBUG
#Preview {
    MyPage.Setting.BodyView(viewModel: .init())
}
#endif
