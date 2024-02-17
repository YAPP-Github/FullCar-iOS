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

        deviceTokenManager.save(deviceToken.base64EncodedString())
        deviceTokenManager.save(deviceToken)
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
