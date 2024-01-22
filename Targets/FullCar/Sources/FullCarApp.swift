import SwiftUI
import FullCarUI

@main
struct FullCarApp: App {
    
    var body: some Scene {
        WindowGroup {
//            RootView(viewModel: .init())
            OnboardingView(viewModel: .init())
        }
    }
}
