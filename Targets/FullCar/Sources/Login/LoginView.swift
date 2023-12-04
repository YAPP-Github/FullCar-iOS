//
//  LoginView.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI
import FullCarKit

@MainActor
@Observable
final class LoginViewModel {
    var appState: FullCar.State = FullCar.shared.appState
    
    func loginButtonTapped() async {
        appState = .tab
    }
}

struct LoginView: View {
    let viewModel: LoginViewModel
    
    var body: some View {
        bodyView
    }
    
    private var bodyView: some View {
        loginButton
    }
    
    private var loginButton: some View {
        Button { 
            Task { await viewModel.loginButtonTapped() }
        } label: {
            Text("로그인 버튼")
        }
    }
}

#Preview {
    LoginView(viewModel: .init())
}
