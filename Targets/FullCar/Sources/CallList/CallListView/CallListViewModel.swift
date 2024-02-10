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
    var selection: FullCar.CallListTab = .request
    
    enum Destination: Hashable {
        case detail(CallListDetailViewModel)
    }
    
    var paths: [Destination] = []
    
    var dummyData: [Dummy] = [.init(status: .waiting),
                              .init(status: .failure),
                              .init(status: .waiting),
                              .init(status: .success),
                              .init(status: .waiting),
                              .init(status: .waiting),
                              .init(status: .success),
                              .init(status: .success),
                              .init(status: .success)]
    
    
    func onAcceptTapped() {
        guard paths.isEmpty else { return }
        let callListDtailViewModel = CallListDetailViewModel()
        
        callListDtailViewModel.onBackButtonTapped = { [weak self] in
            self?.paths.removeAll()
        }
        
        paths.append(.detail(callListDtailViewModel))
    }
}
