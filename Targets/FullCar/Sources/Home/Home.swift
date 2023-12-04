//
//  Home.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class HomeViewModel {
    
} 

struct HomeView: View {
    let viewModel: HomeViewModel
    var body: some View {
        Color.green
    }
}

#Preview {
    HomeView(viewModel: .init())
}
