import SwiftUI
import FullCarUI

class AppDelegate: NSObject, UIApplicationDelegate {
    private(set) var deviceToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        UIApplication.shared.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        // 추후 device token 설정 위해 push alerm 관련 설정하기
        print("device token 입니다 : \(deviceToken)")
        self.deviceToken = String(data: deviceToken, encoding: .utf8)
    }
}

@main
struct FullCarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: .init())
        }
    }
}
