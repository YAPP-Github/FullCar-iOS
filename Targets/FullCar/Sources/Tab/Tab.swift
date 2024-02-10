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

            CallListView(viewModel: .init())
                .tabItem {
                    Text("요청")
                }
                .tag(FullCar.Tab.request)

            CarPullRegisterView(viewModel: .init())
                .tabItem { 
                    Text("register")
                }
                .tag(FullCar.Tab.register)
            
            Car.Register.BodyView(viewModel: .init())
                .tabItem { 
                    Text("car experiment")
                }
                .tag(FullCar.Tab.experiment)
            
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
