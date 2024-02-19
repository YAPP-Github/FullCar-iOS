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
    @ObservationIgnored @Dependency(\.callListAPI) private var callListAPI
    
    enum RequestStatus {
        case beforeBegin
        case inProcess
        case applyAlready
    }
    
    var requestStatus: RequestStatus
    let carPull: CarPull.Model.Information
    var information: Car.Information?
    var onBackButtonTapped: () -> Void = unimplemented("onBackButtonTapped")
    
    var actionSheetOpen: Bool = false
    var alertOpen: Bool = false
    var deleteDoneOpen: Bool = false
    
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
    
    func beginRequestButtonTapped() async {
        await MainActor.run {
            requestStatus = .inProcess
        }
        await applyFullCar()
        
        #if DEBUG
        await MainActor.run {
            requestStatus = .applyAlready
        }
        #endif
    }
    
    func applyFullCar() async {
        do {
            try await callListAPI.applyCarpull(formId: carPull.id, pickupLocation: carPull.pickupLocation, peroidType: carPull.periodType.rawValue, money: carPull.money, content: carPull.content ?? "")
        } catch {
            print("error", error.localizedDescription)
        }
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
