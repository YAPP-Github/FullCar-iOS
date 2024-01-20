//
//  Home.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import SwiftUI
import FullCarUI

@MainActor
struct HomeView: View {
    let viewModel: HomeViewModel
    var body: some View {
        VStack(spacing: .zero) {
            headerView
            bodyView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray10)
        .onFirstTask { await viewModel.onFirstTask() }
    }
    private var headerView: some View {
        HStack(spacing: .zero) {
            Text("야놀자")
                .font(.pretendard18(.bold))
                .foregroundStyle(Color.black80)
            Spacer()
            Image("FCHomeTopTrailingImage", bundle: .main)
        }
        .padding(.leading, 20)
        .padding(.trailing, 15.48)
        .frame(height: 61)
        .frame(maxWidth: .infinity)
        .background(Color.white)
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
        ScrollView(.vertical) { 
            ForEach(list) { carpull in
                Button {
                    Task { await viewModel.onCardTapped(carpull) }
                } label: {
                    HomeCardView(carPull: carpull)
                        .padding(.bottom, 8)
                }
                .buttonStyle(.plain)
            }
        }
        .scrollIndicators(.hidden)
        .refreshable(action: viewModel.refreshable)
    }
    private var emptyView: some View {
        Color.red
    }
}

#if DEBUG
#Preview {
    TabView {
        NavigationStack {
            HomeView(viewModel: .init())
        }
        .tabItem { 
            Text("home")
        }
    }
}
#endif
