//
//  HomeViewModel.swift
//  FullCar
//
//  Created by 한상진 on 12/31/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarKit
import Observation
import Dependencies

@MainActor
@Observable
final class HomeViewModel {
    @ObservationIgnored
    @Dependency(\.homeAPI) private var homeAPI
    var homeResponse: Home.Model.Response?
    
    func onFirstTask() async {
        do {
            let response = try await homeAPI.fetch(id: "id", name: "name")
            self.homeResponse = response
        }
        catch {
            // some error handling
        }
    }
    
    @Sendable
    func refreshable() async {
        print(#function)
    }
    
    func onCardTapped(_ carpull: Home.Model.TempCarPull) async {
        
    }
}
