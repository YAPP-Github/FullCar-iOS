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
    let id : UUID = UUID()
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
            CallListTabView(selection: $viewModel.selection)
                .padding(.top, 20)
            
            TabView(selection: $viewModel.selection,
                    content:  {
                
                CallRequestListView(data: $viewModel.sentData) { item in
                    viewModel.onAcceptTapped(type: .SentRequestDetails, data: item)
                }
                    .tag(FullCar.CallListTab.request)
                
                CallReceiveListView(data: $viewModel.receiveData) { item in
                    viewModel.onAcceptTapped(type: .ReceivedRequestDetails, data: item)
                }
                    .tag(FullCar.CallListTab.receive)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
        }
        .task {
            await viewModel.loadAction(.receive)
            await viewModel.loadAction(.request)
        }
    }
}

#Preview {
    NavigationStack {
        CallListView(viewModel: .init())
    }
}
