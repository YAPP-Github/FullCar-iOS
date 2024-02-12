import SwiftUI
import Dependencies

final class AppDelegate: NSObject, UIApplicationDelegate {
    static var shared: AppDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        AppDelegate.shared = self

        UIApplication.shared.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        @Dependency(\.deviceToken) var deviceTokenManager

        // MARK: 추후 Device token 잘 받아오는지 확인 필요
        deviceTokenManager.save(deviceToken)
    }
}

@main
struct FullCarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            #if DEBUG
            Onboarding.Company.BodyView(viewModel: .init())
            #else
            RootView(viewModel: .init())
            #endif
        }
    }
}
