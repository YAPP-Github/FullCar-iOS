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

        @State private var isShowingLogoutDialog = false
        @State private var isShowingLeaveDialog = false

        @State private var isShowingLogoutAlert = false
        @State private var isShowingLeaveAlert = false

        @State private var didLeaveSuccess = false

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
                logoutView

                leaveView
            }
        }

        private var logoutView: some View {
            buttonItem(text: "로그아웃", action: { isShowingLogoutDialog = true })
                .confirmationDialog(
                    "",
                    isPresented: $isShowingLogoutDialog,
                    titleVisibility: .hidden
                ) {
                    Button("로그아웃", role: .destructive) {
                        isShowingLogoutAlert = true
                    }
                    Button("닫기", role: .cancel) {
                        isShowingLogoutDialog = false
                    }
                }
                .alert(
                    "로그아웃하시겠어요?",
                    isPresented: $isShowingLogoutAlert
                ) {
                    Button("로그아웃", role: .destructive) {
                        Task {
                            await viewModel.logout()
                        }
                    }
                    Button("취소", role: .cancel) {
                        isShowingLogoutAlert = false
                    }
                }
        }

        private var leaveView: some View {
            buttonItem(text: "탈퇴", action: { isShowingLeaveDialog = true })
                .confirmationDialog(
                    "",
                    isPresented: $isShowingLeaveDialog,
                    titleVisibility: .hidden
                ) {
                    Button("탈퇴", role: .destructive) {
                        isShowingLeaveAlert = true
                    }
                    Button("닫기", role: .cancel) {
                        isShowingLeaveDialog = false
                    }
                }
                .alert(
                    "정말 탈퇴하시겠어요?",
                    isPresented: $isShowingLeaveAlert,
                    actions: {
                        Button("탈퇴하기", role: .destructive) {
                            Task {
                                await viewModel.leave(didSuccess: $didLeaveSuccess)
                            }
                        }
                        Button("취소", role: .cancel) {
                            isShowingLeaveAlert = false
                        }
                    },
                    message: { Text("탈퇴 시 재가입이 어려울 수 있으며,\n작성한 모든 게시글에 대한 권한이 소멸됩니다.") }
                )
                .alert(
                    "정상적으로 탈퇴처리 되었습니다.",
                    isPresented: $didLeaveSuccess,
                    actions: {
                        Button("확인", role: .cancel) {
                            didLeaveSuccess = false
                        }
                    }
                )
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
