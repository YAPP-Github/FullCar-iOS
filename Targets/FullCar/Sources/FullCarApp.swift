import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    static var shared: AppDelegate?

    private(set) var deviceToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        AppDelegate.shared = self

        UIApplication.shared.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        // 팀계정 설정되면 device token 받아오기
        print("device token 입니다 : \(deviceToken)")
        self.deviceToken = String(data: deviceToken, encoding: .utf8)
    }
}

@main
struct FullCarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            #if DEBUG
            //Onboarding.Company.BodyView(viewModel: .init())
            RootView(viewModel: .init())
            #else
            RootView(viewModel: .init())
            #endif
        }
    }
}
