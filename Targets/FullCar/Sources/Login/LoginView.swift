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

    @ObservationIgnored @Dependency(\.login) var login

    var appState: FullCar.State = FullCar.shared.appState

    func kakaoLoginButtonTapped() async {
        await login.kakaoLogin() {
            self.appState = .tab
        }
    }

    func appleLoginButtonTapped(result: Result<ASAuthorization, Error>) {
        login.appleLogin(result: result) {
            self.appState = .tab
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
