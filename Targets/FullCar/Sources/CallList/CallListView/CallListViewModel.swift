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
            
            if let error = error as? DecodingError {
                switch error {
                case .typeMismatch(let any, let context):
                    print("typeMismatch", any, context.debugDescription)
                case .valueNotFound(let any, let context):
                    print("valueNotFound", any, context.debugDescription)
                case .keyNotFound(let codingKey, let context):
                    print("keyNotFound", codingKey.stringValue, context.debugDescription)
                case .dataCorrupted(let context):
                    print("dataCorrupted", context.debugDescription)
                }
            }
            
            print("Error", error.localizedDescription)
        }
        
    }
}
