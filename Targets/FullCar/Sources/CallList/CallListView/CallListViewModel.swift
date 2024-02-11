//
//  CallListViewModel.swift
//  FullCar
//
//  Created by Tabber on 2024/02/03.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarKit
import Observation
import Dependencies

@MainActor
@Observable
final class CallListViewModel {
    @ObservationIgnored @Dependency(\.callListAPI) private var callListAPI
    
    var selection: FullCar.CallListTab = .request
    
    enum Destination: Hashable {
        case detail(CallListDetailViewModel)
    }
    
    var paths: [Destination] = []
    
    var receiveData: [CarPull.Model.Information] = []
    var sentData: [CarPull.Model.Information] = []
    
    func onAcceptTapped(type: CallListDetailView.CallListDetailViewType, data: CarPull.Model.Information) {
        guard paths.isEmpty else { return }
        let callListDtailViewModel = CallListDetailViewModel(callListDetailViewType: type, carPullData: data)
        
        callListDtailViewModel.onBackButtonTapped = { [weak self] in
            self?.paths.removeAll()
        }
        
        paths.append(.detail(callListDtailViewModel))
    }
    
    func loadAction(_ type: FullCar.CallListTab) async {
        do {
            switch type {
            case .receive:
                let receiveData = try await callListAPI.fetchReceivedList()
                
                await MainActor.run {
                    self.receiveData = receiveData.data
                }
                
            case .request:
                let sentData = try await callListAPI.fetchSentList()
                
                await MainActor.run {
                    self.sentData = sentData.data
                }
            }
        } catch {
            print("Error", error.localizedDescription)
        }
        
    }
}
