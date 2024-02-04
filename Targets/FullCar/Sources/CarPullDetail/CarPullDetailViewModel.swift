//
//  CarPullDetailViewModel.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import Observation
import Dependencies
import XCTestDynamicOverlay

@MainActor
@Observable
final class CarPullDetailViewModel {
    
    enum RequestStatus {
        case beforeBegin
        case inProcess
    }
    
    var requestStatus: RequestStatus
    let carPull: CarPull.Model.Information
    var information: Car.Information?
    var onBackButtonTapped: () -> Void = unimplemented("onBackButtonTapped")
    
    init(
        requestStatus: RequestStatus = .beforeBegin,
        carPull: CarPull.Model.Information
    ) {
        self.requestStatus = requestStatus
        self.carPull = carPull
    }
    
    func onFirstTask() async {
        // TODO: API call
    }
    
    func beginRequestButtonTapped() {
        requestStatus = .inProcess
    }
} 

extension CarPullDetailViewModel: Hashable {
    nonisolated static func == (lhs: CarPullDetailViewModel, rhs: CarPullDetailViewModel) -> Bool {
        return lhs === rhs
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
