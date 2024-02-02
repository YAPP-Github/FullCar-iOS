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
    
    private var currentPage: Int = 1
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
        clear()
    }
    
    func onCardTapped(_ carpull: CarPull.Model.Response) async {
        
    }
    
    private func clear() {
        self.currentPage = 1
        
    }
}
