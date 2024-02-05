import SwiftUI
import FullCarUI

@main
struct FullCarApp: App {
    
    var body: some Scene {
        WindowGroup {
            #if DEBUG
//            CompanySelectView(viewModel: .init())
            OnboardingView(viewModel: .init())
            #else
            RootView(viewModel: .init())
            #endif
        }
    }
}
