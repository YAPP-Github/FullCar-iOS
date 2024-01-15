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

enum LoginType {
    case kakao
    case apple

    var title: String {
        switch self {
        case .kakao: return "카카오 로그인"
        case .apple: return "Apple로 로그인"
        }
    }

    var icon: Image {
        switch self {
        case .kakao: return Image(icon: .kakaoLogo)
        case .apple: return Image(icon: .appleLogo)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .kakao: return Color(cgColor: UIColor(hex: "FEE500").cgColor)
        case .apple: return .black
        }
    }

    var fontColor: Color {
        switch self {
        case .kakao: return Color.black.opacity(0.85)
        case .apple: return .white
        }
    }
}

@MainActor
@Observable
final class LoginViewModel {
    @ObservationIgnored @Dependency(\.fullCarAccount) var account

    let fullCar = FullCar.shared

    init() {
        configureAppleLogin()
    }

    func loginButtonTapped(for type: LoginType) async {
        switch type {
        case .kakao: await startKakaoLogin()
        case .apple: startAppleLogin()
        }
    }

    private func startKakaoLogin() async {
        do {
            try await account.kakaoLogin()
            fullCar.appState = .tab
        } catch {
            fullCar.appState = .login
            print(error)
        }
    }

    private func startAppleLogin() {
        account.appleLogin()
    }

    // 어짜피 로그인은 한번 뿐이니, 카카오 로그인 또한 클로저로 실행?
    // 아니면 카카오 로그인처럼 애플 로그인 continuation 사용해서 async/await 사용하도록 변경하는건? (이거 우선 실행 ㄱㄱ)
    private func configureAppleLogin() {
        account.appleAuthorizationHandler = { [weak self] result in
            switch result {
            case .success:
                self?.fullCar.appState = .tab
            case .failure(let error):
                self?.fullCar.appState = .login
                print(error)
            }
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
            Spacer()

            title
                .padding(.bottom, 57)

            logoImage

            Spacer()

            loginButton(for: .kakao)
            loginButton(for: .apple)
        }
        .padding(.bottom, 55)
        .padding(.horizontal, 20)
    }

    private var title: some View {
        VStack(spacing: 16) {
            VStack {
                Text("회사공개를 통한")

                HStack(spacing: 0) {
                    Text("안전한 카풀, ")
                    Text("풀카")
                        .foregroundStyle(Color.fullCar_primary)
                }
            }
            .font(.pretendard28(.bold))

            Text("검증된 사람들과 즐겁게 카풀 해보세요!")
                .font(.pretendard16(.regular))
        }
    }

    private var logoImage: some View {
        Image(icon: .homeLogo)
            .frame(width: 238, height: 192)
            .padding(.trailing, 20)
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
                        .frame(width: 32, height: 32)
                        .padding(.leading, 7)
                case .apple:
                    type.icon
                        .padding(.leading, 7)
                }
                Text(type.title)
                    .font(.pretendard19(.medium))
                    .foregroundStyle(type.fontColor)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 44)
            .background(type.backgroundColor)
            .cornerRadius(radius: 7, corners: .allCorners)
        }
    }
}

#Preview {
    LoginView(viewModel: .init())
}
