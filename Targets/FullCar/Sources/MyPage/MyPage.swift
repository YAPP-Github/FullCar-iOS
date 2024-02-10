//
//  MyPage.swift
//  FullCar
//
//  Created by Sunny on 2/10/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

import Dependencies
import FullCarUI
import FullCarKit

struct MyPage {
    enum MyCarpool { }
    enum MyCar { }
    enum Question { }
    enum Announcement { }
    enum Inquiry { }
    enum TermsAndPolicies { }
    enum Setting { }
}

extension MyPage {
    @MainActor
    @Observable
    final class ViewModel {
        @ObservationIgnored
        @Dependency(\.myPageAPI) private var myPageAPI

        var appState: FullCar.State = FullCar.shared.appState

        func logout() async {
            do {
                try await myPageAPI.logout()

                appState = .login
            } catch {
                print(error)

                // 로그아웃 실패했을시?
            }
        }

        func leave(didSuccess: Binding<Bool>) async {
            do {
                try await myPageAPI.leave()

                appState = .login
                didSuccess.wrappedValue = true
            } catch {
                print(error)

                // 탈퇴 실패했을시?
            }
        }
    }
}

extension MyPage {
    @MainActor
    struct BodyView: View {
        @Bindable var viewModel: ViewModel

        var body: some View {
            NavigationStack {
                bodyView
                    .navigationBarStyle(
                        leadingView: { },
                        centerView: {
                            Text("마이페이지")
                                .font(.pretendard18(.bold))
                        },
                        trailingView: { }
                    )
            }
        }

        private var bodyView: some View {
            VStack(alignment: .leading, spacing: .zero) {
                profile

                navigationItemLink(Text("내카풀"), icon: .car, text: "내 카풀")
                navigationItemLink(Text("차량 정보 관리"), icon: .userCard, text: "차량 정보 관리")

                Divider()
                    .overlay(Color.gray30)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)

                navigationItemLink(Text("자주 뭍는 질문"), icon: .help, text: "자주 뭍는 질문")
                navigationItemLink(Text("공지사항"), icon: .note, text: "공지사항")
                navigationItemLink(Text("1:1 문의"), icon: .chat, text: "1:1 문의")
                navigationItemLink(Text("약관 및 정책"), icon: .shield_check, text: "약관 및 정책")
                navigationItemLink(MyPage.Setting.BodyView(viewModel: viewModel), icon: .setting, text: "설정")
            }
        }

        private var profile: some View {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: 4) {
                    Text("피곤한 물개")
                        .font(.pretendard16(.bold))

                    Text("· 현대자동차")
                        .font(.pretendard14(.medium))
                        .foregroundStyle(Color.gray60)
                }
                .padding(20)

                Divider()
                    .frame(height: 8)
                    .overlay(Color.gray10)
            }
        }

        private func navigationItemLink<Destination: View>(
            _ destination: Destination,
            icon: FCIcon.Symbol,
            text: String
        ) -> some View {
            NavigationLink(destination: destination) {
                HStack(alignment: .center, spacing: 6) {
                    Image(icon: icon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(iconSize: ._24)
                        .foregroundStyle(Color.black80)

                    Text(text)
                        .font(.pretendard16(.medium))
                        .foregroundStyle(Color.black80)

                    Spacer()

                    Image(icon: .chevron_right)
                        .frame(iconSize: ._20)
                        .foregroundStyle(Color.gray60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 18)
            }
        }
    }
}

#if DEBUG
#Preview {
    MyPage.BodyView(viewModel: .init())
}
#endif
