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
    @Bindable var viewModel: HomeViewModel
    var body: some View {
        NavigationStack(path: $viewModel.paths) {
            _body
                .navigationDestination(for: HomeViewModel.Destination.self) { destination in
                    switch destination {
                    case let .detail(detailViewModel):
                        CarPullDetailView(viewModel: detailViewModel)
                    }
                }
                .onTapGesture {
                    let carpull: CarPull.Model.Information = .init(id: 0,
                                                                   pickupLocation: "봉천역",
                                                                   periodType: .oneWeek,
                                                                   money: 10000,
                                                                   content: "봉천역에서 카풀해요~",
                                                                   moodType: .quiet,
                                                                   formState: .REQUEST,
                                                                   carpoolState: .OPEN,
                                                                   nickname: "알뜰한 물개",
                                                                   companyName: "현대자동차",
                                                                   gender: .male,
                                                                   resultMessage: .init(contact: "탑승자에게 보내는 메시지", toPassenger: "연락은 카톡으로 드리겠습니다~\n내일 뵙겠습니다."),
                                                                   createdAt: Date())
                    Task { await viewModel.onCardTapped(carpull) }
                }
        }
    }
    private var _body: some View {
        VStack(spacing: .zero) {
            headerView
            bodyView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray10)
        .onFirstTask { await viewModel.onFirstTask() }
    }
    private var headerView: some View {
        VStack(spacing: .zero) {
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
            
            Divider().frame(height: 1)
        }
    }
    @ViewBuilder
    private var bodyView: some View {
        if viewModel.error != nil {
            errorView(imageName: "error_home")
                .transition(.fadeInOut)
        } else if viewModel.carPullList.isEmpty {
            errorView(imageName: "empty_home")
                .transition(.fadeInOut)
        } else {
            carPullList(viewModel.carPullList)
                .transition(.fadeInOut)
        }
    }
    private func errorView(imageName: String) -> some View {
        VStack(spacing: .zero) {
            Image("error_home", bundle: .main)
                .padding(.bottom, 24)
            Button {
                Task {
                    await viewModel.retryButtonTapped()
                }
            } label: {
                if viewModel.apiIsInFlight {
                    ProgressView().id(UUID())
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .transition(.fadeInOut)
                        .frame(width: 116)
                } else {
                    Text("다시 불러오기")
                        .transition(.fadeInOut)
                        .frame(width: 116)
                }
            }
            .buttonStyle(.fullCar(horizontalPadding: 16, style: .palette(.primary_white)))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    private func carPullList(_ list: [CarPull.Model.Information]) -> some View {
        ScrollView(.vertical) { 
            LazyVStack(spacing: .zero) {
                ForEach(Array(list.enumerated()), id: \.element) { index, carpull in
                    Button {
                        Task { await viewModel.onCardTapped(carpull) }
                    } label: {
                        CarPull.CardView(carPull: carpull)
                            .padding(.bottom, 8)
                    }
                    .buttonStyle(.plain)
                    .task {
                        await viewModel.rowAppeared(at: index)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .refreshable(action: viewModel.refreshable)
    }
}

#if DEBUG
#Preview {
    TabView {
        HomeView(viewModel: .init())
            .tabItem { 
                Text("home")
            }
    }
}
#endif
