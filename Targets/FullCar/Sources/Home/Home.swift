//
//  Home.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI
import FullCarKit
import Observation
import Dependencies

@MainActor
@Observable
final class HomeViewModel {
    @ObservationIgnored
    @Dependency(\.homeAPI) private var homeAPI
    
    func fetchHome() async {
        do {
            let response = try await homeAPI.fetch(id: "id", name: "name")
        }
        catch {
            // some error handling
        }
    }
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
