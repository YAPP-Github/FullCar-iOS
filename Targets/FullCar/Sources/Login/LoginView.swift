//
//  LoginView.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class LoginViewModel {
    
}

struct LoginView: View {
    let viewModel: LoginViewModel
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    LoginView(viewModel: .init())
}
