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
    
    enum Constants {
        static let startPage: Int = .zero
    }
    
    enum Destination: Hashable {
        case detail(CarPullDetailViewModel)
    }
    
    @ObservationIgnored
    @Dependency(\.carpullAPI) private var carpullAPI
    @ObservationIgnored
    @Dependency(\.fullCar) private var fullCar
    
    var paths: [Destination] = []
    private(set) var carPullList: [CarPull.Model.Information] = []
    private(set) var apiIsInFlight: Bool = false
    private(set) var error: Error?
    var companyName: String { fullCar.member?.company.name ?? "" }
    
    private var currentPage: Int = Constants.startPage
    
    // MARK: Action
    
    func onFirstTask() async {
        await fetchCarPulls(page: currentPage)
    }
    
    func rowAppeared(at index: Int) async {
        guard index.hasReachedThreshold(outOf: carPullList.count) else { return }
        guard !apiIsInFlight else { return }
        await fetchCarPulls(page: currentPage)
    }
    
    @Sendable
    func refreshable() async {
        self.currentPage = Constants.startPage
        await fetchCarPulls(page: self.currentPage)
    }
    
    func onCardTapped(_ carpull: CarPull.Model.Information) {
        guard paths.isEmpty else { return }
        let detailViewModel = CarPullDetailViewModel(openType: .Home, carPull: carpull)
        // TODO: 먼저 지워지는거 수정
        detailViewModel.onBackButtonTapped = { [weak self] in
            self?.paths.removeAll()
        }
        paths.append(.detail(detailViewModel))
    }
    
    func retryButtonTapped() async {
        await fetchCarPulls(page: self.currentPage)
    }
    
    // MARK: Private
    
    private func fetchCarPulls(page: Int) async {
        do {
            apiIsInFlight = true
            defer { apiIsInFlight = false }
            
            let response = try await carpullAPI.fetch(page: currentPage)
            self.error = .none
            
            if page == Constants.startPage {
                carPullList = response.data.carPullList
            } else {
                carPullList.append(contentsOf: response.data.carPullList)
            }
            
            currentPage += 1
        }
        catch {
            self.error = error
        }
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
