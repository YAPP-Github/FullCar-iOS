//
//  LoginView.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI
import FullCarKit
import Dependencies
import AuthenticationServices

@MainActor
@Observable
final class LoginViewModel {
    @ObservationIgnored @Dependency(\.fullCarAccount) var account

    let fullCar = FullCar.shared

    func kakaoLoginButtonTapped() async {
        await account.kakaoLogin() {
            self.fullCar.appState = .tab
        }
    }

    func appleLoginButtonTapped(result: Result<ASAuthorization, Error>) {
        account.appleLogin(result: result) {
            self.fullCar.appState = .tab
        }
    }
}

struct LoginView: View {
    let viewModel: LoginViewModel
    
    var body: some View {
        bodyView
    }
    
    private var bodyView: some View {
        VStack {
            kakaoLoginButton
            appleLoginButton
                // 임시 크기 설정
                .frame(height: 50)
        }
    }
    
    private var kakaoLoginButton: some View {
        Button {
            Task { await viewModel.kakaoLoginButtonTapped() }
        } label: {
            Text("카카오 로그인 버튼")
        }
    }

    private var appleLoginButton: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = []
        } onCompletion: { result in
            Task { await viewModel.appleLoginButtonTapped(result: result) }
        }
    }
}

#Preview {
    LoginView(viewModel: .init())
}
