//
//  LoginView.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI
import FullCarKit
import FullCarUI
import Dependencies

struct Login { }

extension Login {
    @MainActor
    @Observable
    final class ViewModel {
        @ObservationIgnored
        @Dependency(\.fullCar) private var fullCar

        @ObservationIgnored
        @Dependency(\.loginAPI) var loginAPI
        @ObservationIgnored
        @Dependency(\.onbardingAPI) private var onboardingAPI

        var isShowLoginErrorAlert: Bool = false

        private let throttler = Throttler(duration: 2)

        func loginButtonTapped(for type: SocialType) async {
            await throttler.execute { [weak self] in
                await self?.login(for: type)
            }
        }

        private func login(for type: SocialType) async {
            do {
                try await loginAPI.performLogin(type)

                let member = try await onboardingAPI.fetch()
                if member.company.name.isEmpty {
                    fullCar.appState = .onboarding    
                } else {
                    fullCar.appState = .tab(member)
                }

                // 로그인 성공시, device token 등록
                await loginAPI.registerDeviceToken()
                #if DEBUG
                print("[✅][LoginViewModel.swift] -> 로그인 성공!")
                #endif
            } catch {
                isShowLoginErrorAlert = true

                #if DEBUG
                print("[🆘][LoginViewModel.swift] -> 로그인 실패 : \(error)")
                #endif
            }
        }
    }
}

extension Login {
    @MainActor
    struct BodyView: View {
        @Bindable var viewModel: ViewModel

        var body: some View {
            bodyView
                .padding(.horizontal, 20)
                .alert(
                    "로그인할 수 없음",
                    isPresented: $viewModel.isShowLoginErrorAlert,
                    actions: {
                        Button(action: { }, label: { Text("확인") })
                    },
                    message: { Text("에러가 발생했어요. 다시 시도해주세요.") })
        }

        private var bodyView: some View {
            VStack(spacing: .zero) {
                VStack(spacing: 16) {
                    title
                    subtitle
                }
                .padding(.bottom, 57)

                Image(icon: .homeLogo)
                    .padding(.bottom, 148)

                VStack(spacing: 10) {
                    loginButton(for: .kakao)
                    loginButton(for: .apple)
                }
            }
        }

        private var title: some View {
            VStack {
                Text("회사공개를 통한")

                HStack(spacing: .zero) {
                    Text("안전한 카풀, ")
                    Text("풀카")
                        .foregroundStyle(Color.fullCar_primary)
                }
            }
            .font(.pretendard28(.bold))
        }

        private var subtitle: some View {
            Text("검증된 사람들과 즐겁게 카풀 해보세요!")
                .font(.pretendard16(.regular))
        }

        private func loginButton(for type: SocialType) -> some View {
            Button {
                Task {
                    await viewModel.loginButtonTapped(for: type)
                }
            } label: {
                ZStack(alignment: .leading) {
                    socialIcon(type)

                    Text(socialLoginStyle(type).title)
                        .frame(maxWidth: .infinity)
                }
                .font(.pretendard19(.medium))
                .foregroundStyle(socialLoginStyle(type).fontColor)
                .frame(height: 44)
                .background(socialLoginStyle(type).backgroundColor)
                .cornerRadius(radius: 7, corners: .allCorners)
            }
        }

        @ViewBuilder
        private func socialIcon(_ type: SocialType) -> some View {
            switch type {
            case .kakao:
                LoginStyle.kakao.icon
                    .resizable()
                    .frame(iconSize: ._32)
                    .padding(.leading, 15)
            case .apple:
                LoginStyle.apple.icon
                    .frame(iconSize: ._32)
                    .padding(.leading, 15)
            }
        }

        private func socialLoginStyle(_ type: SocialType) -> LoginStyle {
            switch type {
            case .kakao: return LoginStyle.kakao
            case .apple: return LoginStyle.apple
            }
        }
    }
}

#Preview {
    Login.BodyView(viewModel: .init())
}
