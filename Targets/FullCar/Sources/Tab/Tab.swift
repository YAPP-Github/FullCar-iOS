//
//  Tab.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Observation

@MainActor
@Observable
final class TabViewModel {
    var tabSelection: FullCar.Tab = .home
} 

struct FullCarTabView: View {
    @Bindable var viewModel: TabViewModel
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
            HomeView(viewModel: .init())
                .tabItem { 
                    Text("home")
                }
                .tag(FullCar.Tab.home)
            SettingsView(viewModel: .init())
                .tabItem { 
                    Text("setting")
                }
                .tag(FullCar.Tab.settings)
        }
    }
}

#Preview {
    FullCarTabView(viewModel: .init())
}
