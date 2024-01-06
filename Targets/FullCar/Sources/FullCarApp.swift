import SwiftUI
import FullCarUI
import Firebase

@main
struct FullCarApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: .init())
        }
    }
}
