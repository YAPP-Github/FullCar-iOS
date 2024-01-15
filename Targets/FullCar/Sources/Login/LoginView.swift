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

    func loginButtonTapped(for type: LoginType) async {
        do {
            try await account.performLogin(type)
            fullCar.appState = .tab
        } catch {
            fullCar.appState = .login
            print(error)
        }
    }
}

struct LoginView: View {
    let viewModel: LoginViewModel

    var body: some View {
        bodyView
            .debug(color: .red)
    }

    private var bodyView: some View {
        VStack(spacing: 0) {
//            Spacer()

            title
                .debug()
                .padding(.bottom, 16)
                .padding(.top, 85)

            subTitle
                .padding(.bottom, 57)

//            Spacer()

            Image(icon: .homeLogo)
                .padding(.bottom, 148)

//            Spacer()

            VStack(spacing: 10) {
                loginButton(for: .kakao)
                loginButton(for: .apple)
            }
            .padding(.bottom, 50)
        }
        .padding(.horizontal, 20)
    }

    private var title: some View {
        VStack {
            Text("회사공개를 통한")

            HStack(spacing: 0) {
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

    private func loginButton(for type: LoginType) -> some View {
        Button {
            Task { await viewModel.loginButtonTapped(for: type) }
        } label: {
            ZStack(alignment: .leading) {
                switch type {
                case .kakao:
                    type.icon
                        .resizable()
                        .frame(iconSize: ._32)
                        .padding(.leading, Constants.LoginButton.iconLeading)
                case .apple:
                    type.icon
                        .frame(iconSize: ._32)
                        .padding(.leading, Constants.LoginButton.iconLeading)
                }
                Text(type.title)
                    .frame(maxWidth: .infinity)
            }
            .font(.pretendard19(.medium))
            .foregroundStyle(type.fontColor)
            .frame(height: Constants.LoginButton.height)
            .background(type.backgroundColor)
            .cornerRadius(radius: Constants.LoginButton.radius, corners: .allCorners)
        }
    }
}

extension LoginView {
    enum Constants {
        enum LoginButton {
            static let height: CGFloat = 44
            static let radius: CGFloat = 7
            static let iconLeading: CGFloat = 15
        }
    }
}

#Preview {
    LoginView(viewModel: .init())
}
