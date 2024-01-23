//
//  CallList.swift
//  FullCar
//
//  Created by Tabber on 2024/01/06.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Observation

struct Dummy: Hashable {
    let id : UUID = UUID()
    let status: FullCar.CallStatus
}

@MainActor
@Observable
final class CallListViewModel {
    var selection: FullCar.CallListTab = .request
    
    var dummyData: [Dummy] = [.init(status: .waiting),
                              .init(status: .failure),
                              .init(status: .waiting),
                              .init(status: .success),
                              .init(status: .waiting),
                              .init(status: .waiting),
                              .init(status: .success),
                              .init(status: .success),
                              .init(status: .success)]
}


struct CallList: View {
    @Bindable var viewModel: CallListViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            CallListTabView(selection: $viewModel.selection)
            
            TabView(selection: $viewModel.selection,
                    content:  {
                CallRequestListView(data: $viewModel.dummyData)
                    .tag(FullCar.CallListTab.request)
                CallReceiveListView(data: $viewModel.dummyData)
                    .tag(FullCar.CallListTab.receive)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
            
        }
        .ignoresSafeArea(edges: .bottom)
        
    }
}

#Preview {
    CallList(viewModel: .init())
}
