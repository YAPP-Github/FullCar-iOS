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
    
    enum Destination: Hashable {
        case detail(CarPullDetailViewModel)
    }
    
    @ObservationIgnored
    @Dependency(\.homeAPI) private var homeAPI
    
    var paths: [Destination] = []
    var carPullList: [CarPull.Model.Response] = []
    var apiIsInFlight: Bool = false
    
    private var currentPage: Int = 1
    private var homeResponse: Home.Model.Response?
    
    func onFirstTask() async {
        await fetchCarPulls(page: currentPage)
    }
    
    func rowAppeared(at index: Int) async {
        guard index.hasReachedThreshold(outOf: carPullList.count) else { return }
        guard !apiIsInFlight else { return }
        await fetchCarPulls(page: currentPage)
    }
    
    private func fetchCarPulls(page: Int) async {
        do {
            apiIsInFlight = true
            defer { apiIsInFlight = false }
            
            let response = try await homeAPI.fetch(page: currentPage)
            self.homeResponse = response
            
            if page == 1 {
                carPullList = response.data.carPullList
            } else {
                carPullList.append(contentsOf: response.data.carPullList)
            }
            
            currentPage += 1
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
        guard paths.isEmpty else { return }
        let detailViewModel = CarPullDetailViewModel(carPull: carpull)
        // TODO: 먼저 지워지는거 수정
        detailViewModel.onBackButtonTapped = { [weak self] in
            self?.paths.removeAll()
        }
        paths.append(.detail(detailViewModel))
    }
    
    private func clear() {
        self.currentPage = 1
        self.carPullList.removeAll()
        self.homeResponse = .none
    }
}

fileprivate extension Int {
    func hasReachedThreshold(
        outOf totalCount: Int,
        threshold: Int = 5
    ) -> Bool {
        if self > totalCount - threshold {
            return true
        } else {
            return false
        }
    }
}
