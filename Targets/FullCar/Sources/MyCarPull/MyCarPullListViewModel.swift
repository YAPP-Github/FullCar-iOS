//
//  MyCarPullListViewModel.swift
//  FullCar
//
//  Created by Tabber on 2024/02/11.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarKit
import FullCarUI
import Observation
import Dependencies
import XCTestDynamicOverlay

@MainActor
@Observable
final class MyCarPullListViewModel {
    @ObservationIgnored
    @Dependency(\.myCarPullAPI) private var myCarPullAPI
    
    var myCarPullList: [CarPull.Model.Information] = []
    
    var onSelect: (CarPull.Model.Information) -> Void = unimplemented("")
    
    init() {}
    
    func fetch() async {
        do {
            let value = try await myCarPullAPI.fetch()
            self.myCarPullList = value.data
        } catch {
            print("error", error.localizedDescription)
        }
    }
}
extension MyCarPullListViewModel: Hashable {
    nonisolated static func == (lhs: MyCarPullListViewModel, rhs: MyCarPullListViewModel) -> Bool {
        return lhs === rhs
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
