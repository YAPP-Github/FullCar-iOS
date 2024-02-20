//
//  CallListView.swift
//  FullCar
//
//  Created by Tabber on 2024/01/06.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Observation
import Dependencies

struct Dummy: Hashable {
    let id: UUID = UUID()
    let status: FullCar.CallStatus
}

@MainActor
struct CallListView: View {
    @Bindable var viewModel: CallListViewModel    
    
    var body: some View {
        
        NavigationStack(path: $viewModel.paths) {
            _body
                .navigationDestination(for: CallListViewModel.Destination.self) { destination in
                    switch destination {
                    case let .detail(callListDetailViewModel):
                        CallListDetailView(viewModel: callListDetailViewModel)
                    }
                }
                .navigationBarStyle(
                    leadingView: { },
                    centerView: {
                        Text("요청내역")
                            .font(.pretendard18(.bold))
                            
                    },
                    trailingView: { }
                )
        }
    }
    
    
    private var _body: some View {
        VStack(spacing: 0) {
            CallListTabView(selection: $viewModel.selection, requests: $viewModel.sentData, receives: $viewModel.receiveData)
                .padding(.top, 20)
            
            TabView(selection: $viewModel.selection,
                    content:  {
                
                if viewModel.sentData.isEmpty {
                    errorView(imageName: "carpullListIsEmpty")
                        .transition(.fadeInOut)
                        .tag(FullCar.CallListTab.request)
                } else {
                    CallRequestListView(data: $viewModel.sentData) { item in
                        viewModel.onAcceptTapped(type: .SentRequestDetails, data: item)
                    }
                        .tag(FullCar.CallListTab.request)
                        .transition(.fadeInOut)
                }
                
                if viewModel.receiveData.isEmpty {
                    errorView(imageName: "receiveCarpullIsEmpty")
                        .transition(.fadeInOut)
                        .tag(FullCar.CallListTab.receive)
                } else {
                    CallReceiveListView(data: $viewModel.receiveData) { item in
                        viewModel.onAcceptTapped(type: .ReceivedRequestDetails, data: item)
                    }
                        .tag(FullCar.CallListTab.receive)
                }
                
                
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
        }
        .task {
            await viewModel.loadAction(.receive)
            await viewModel.loadAction(.request)
        }
    }
    
    private func errorView(imageName: String) -> some View {
        VStack(spacing: .zero) {
            Image(imageName)
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        CallListView(viewModel: .init())
    }
}
