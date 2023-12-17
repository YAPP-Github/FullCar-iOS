import SwiftUI
import FullCarUI
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct FullCarApp: App {

    init() {
        setupKakaoSDK()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: .init())
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }

    private func setupKakaoSDK() {
//        guard let kakaoNativeAppKey = Bundle.main.kakaoNativeAppKey else { return }
//        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
}
