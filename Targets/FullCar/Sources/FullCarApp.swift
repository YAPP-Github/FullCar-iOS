import SwiftUI
import FullCarUI

@main
struct FullCarApp: App {
    
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            CompanySearchView(viewModel: .init())
            #else
            RootView(viewModel: .init())
            #endif
        }
    }
}
