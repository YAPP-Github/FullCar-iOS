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

@MainActor
@Observable
final class LoginViewModel {
    @ObservationIgnored @Dependency(\.fullCarAccount) var account

    let fullCar = FullCar.shared

    func loginButtonTapped(for type: SocialType) async {
        do {
            try await account.performLogin(type)
            fullCar.appState = .tab

            #if DEBUG
            print("[✅][LoginViewModel.swift] -> 로그인 성공!")
            #endif
        } catch {
            fullCar.appState = .login

            #if DEBUG
            print("[🆘][LoginViewModel.swift] -> 로그인 실패 : \(error)")
            #endif
        }
    }
}

struct LoginView: View {
    @Bindable var viewModel: LoginViewModel

    var body: some View {
        bodyView
            .padding(.horizontal, Constants.horizontal)
    }

    private var bodyView: some View {
        VStack(spacing: .zero) {
            VStack(spacing: Constants.Title.spacing) {
                title
                subTitle
            }
            .padding(.bottom, Constants.Title.bottom)

            Image(icon: .homeLogo)
                .padding(.bottom, Constants.Image.bottom)

            VStack(spacing: Constants.LoginButton.spacing) {
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

    private var subTitle: some View {
        Text("검증된 사람들과 즐겁게 카풀 해보세요!")
            .font(.pretendard16(.regular))
    }

    private func loginButton(for type: SocialType) -> some View {
        Button {
            Task { await viewModel.loginButtonTapped(for: type) }
        } label: {
            ZStack(alignment: .leading) {
                socialIcon(type)

                Text(socialLoginStyle(type).title)
                    .frame(maxWidth: .infinity)
            }
            .font(.pretendard19(.medium))
            .foregroundStyle(socialLoginStyle(type).fontColor)
            .frame(height: Constants.LoginButton.height)
            .background(socialLoginStyle(type).backgroundColor)
            .cornerRadius(radius: Constants.LoginButton.radius, corners: .allCorners)
        }
    }

    @ViewBuilder
    private func socialIcon(_ type: SocialType) -> some View {
        switch type {
        case .kakao:
            LoginStyle.kakao.icon
                .resizable()
                .frame(iconSize: ._32)
                .padding(.leading, Constants.Image.leading)
        case .apple:
            LoginStyle.apple.icon
                .frame(iconSize: ._32)
                .padding(.leading, Constants.Image.leading)
        }
    }

    private func socialLoginStyle(_ type: SocialType) -> LoginStyle {
        switch type {
        case .kakao: return LoginStyle.kakao
        case .apple: return LoginStyle.apple
        }
    }
}

extension LoginView {
    enum Constants {
        static let horizontal: CGFloat = 20
        
        enum LoginButton {
            static let height: CGFloat = 44
            static let radius: CGFloat = 7
            static let spacing: CGFloat = 10
        }

        enum Title {
            static let spacing: CGFloat = 16
            static let bottom: CGFloat = 57
        }

        enum Image {
            static let bottom: CGFloat = 148
            static let leading: CGFloat = 15
        }
    }
}

#Preview {
    LoginView(viewModel: .init())
}
