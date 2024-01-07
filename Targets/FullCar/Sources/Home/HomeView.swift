//
//  Home.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI

@MainActor
struct HomeView: View {
    let viewModel: HomeViewModel
    var body: some View {
        bodyView
            .onFirstTask { await viewModel.onFirstTask() }
    }
    @ViewBuilder
    private var bodyView: some View {
        if let list = viewModel.homeResponse?.list {
            carPullList(list)
        } else {
            emptyView
        }
    }
    private func carPullList(_ list: [Home.Model.TempCarPull]) -> some View {
        ForEach(list) { carpull in
            HomeCard(carPull: carpull)
        }
        .refreshable(action: viewModel.refreshable)
    }
    private var emptyView: some View {
        Color.red
    }
}

#Preview {
    HomeView(viewModel: .init())
}
