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
    var tabSelection: FullCar.Tab
    let homeViewModel: HomeViewModel = .init()
    let callListViewModel: CallListViewModel = .init()
    let carPullRegisterViewModel: CarPullRegisterViewModel = .init()
    let settingsViewModel: SettingsViewModel = .init()
    
    init(tabSelection: FullCar.Tab = .home) {
        self.tabSelection = tabSelection
        
        carPullRegisterViewModel.changeTabToHome = { [weak self] in
            self?.tabSelection = .home
        }
    }
} 

struct FullCarTabView: View {
    @Bindable var viewModel: TabViewModel
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
            HomeView(viewModel: viewModel.homeViewModel)
                .tabItem {
                    if viewModel.tabSelection == .home {
                        Image("ic_home_selected", bundle: .main)
                    } else {
                        Image("ic_home", bundle: .main)
                    }
                    Text("홈")
                        .font(.pretendard13(.bold))
                        .foregroundStyle(Color.primary)
                }
                .tag(FullCar.Tab.home)
            
            CarPullRegisterView(viewModel: viewModel.carPullRegisterViewModel)
                .tabItem { 
                    if viewModel.tabSelection == .register {
                        Image("ic_carpull_register_selected", bundle: .main)
                    } else {
                        Image("ic_carpull_register", bundle: .main)
                    }
                    Text("카풀등록")
                        .font(.pretendard13(.bold))
                        .foregroundStyle(Color.primary)
                }
                .tag(FullCar.Tab.register)

            CallListView(viewModel: viewModel.callListViewModel)
                .tabItem { 
                    if viewModel.tabSelection == .requestList {
                        Image("ic_request_list_selected", bundle: .main)
                    } else {
                        Image("ic_request_list", bundle: .main)
                    }
                    Text("요청내역")
                        .font(.pretendard13(.bold))
                        .foregroundStyle(Color.primary)
                }
                .tag(FullCar.Tab.requestList)
            
            SettingsView(viewModel: viewModel.settingsViewModel)
                .tabItem { 
                    if viewModel.tabSelection == .myPage {
                        Image("ic_mypage_selected", bundle: .main)
                    } else {
                        Image("ic_mypage", bundle: .main)
                    }
                    Text("마이페이지")
                        .font(.pretendard13(.bold))
                        .foregroundStyle(Color.primary)
                }
                .tag(FullCar.Tab.myPage)
        }
    }
}

#Preview {
    FullCarTabView(viewModel: .init(tabSelection: .home))
}
