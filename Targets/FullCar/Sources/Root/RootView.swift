//
//  RootView.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Firebase
import Observation
import Dependencies
import KakaoSDKAuth
import KakaoSDKCommon

@MainActor
@Observable
final class RootViewModel {
    @ObservationIgnored @Dependency(\.accountService) private var account

    var appState: FullCar.State = FullCar.shared.appState

    // 자동로그인 시도
    // 로컬 스토리지에 토큰 있는지 검사해서, 유효성 검사하고
    // 홈으로 이동할거고
    // 토큰이 없으면 로그인 화면으로
    func onFirstTask() async {
        do {
            let isValidToken = try await account.hasValidToken()
            appState = isValidToken ? .tab : .login

            #if DEBUG
            print("[✅][RootView.swift] -> 자동 로그인 성공!")
            #endif
        } catch {
            appState = .login

            #if DEBUG
            print("[🆘][RootView.swift] -> 자동 로그인 실패 : \(error)")
            #endif
        }
    }

    func setupFirebase() async {
        FirebaseApp.configure()
    }
    
    func setupKakaoSDK() async {
        guard let kakaoNativeAppKey = Bundle.main.kakaoNativeAppKey else { return }
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }

    func handleKakaoURL(_ url: URL) {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
}

struct RootView: View {
    let viewModel: RootViewModel
    
    var body: some View {
        bodyView
            .onOpenURL { url in
                viewModel.handleKakaoURL(url)
            }
            .onFirstTask {
                await viewModel.setupFirebase()
                await viewModel.setupKakaoSDK()
                await viewModel.onFirstTask()
            }
    }
    
    @MainActor
    @ViewBuilder
    private var bodyView: some View {
        switch viewModel.appState {
        case .root:
            Color.red
//            Image("런치스크린 이미지 나오면!", bundle: .main)
                
        case .login:
//            LoginView(
//                viewModel: withDependencies({
//                    $0.accountService = .testValue
//                }, operation: {
//                    LoginViewModel()
//                })
//            )
            LoginView(viewModel: .init())
        case .tab:
            FullCarTabView(viewModel: .init())
        }
    }
}

#Preview {
    RootView(viewModel: .init())
}
