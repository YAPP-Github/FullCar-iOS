//
//  CarPullDetailViewModel.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class CarPullDetailViewModel {
    
    enum RequestStatus {
        case beforeBegin
        case inProcess
    }
    
    var requestStatus: RequestStatus = .beforeBegin
    let carPull: CarPull.Model.Response
    let information: Car.Information
    
    init(
        requestStatus: RequestStatus,
        carPull: CarPull.Model.Response,
        information: Car.Information
    ) {
        self.requestStatus = requestStatus
        self.carPull = carPull
        self.information = information
    }
    
    func beginRequestButtonTapped() {
        requestStatus = .inProcess
    }
} 
