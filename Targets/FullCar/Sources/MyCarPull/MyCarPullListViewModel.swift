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


@MainActor
@Observable
final class MyCarPullListViewModel {
    @ObservationIgnored
    @Dependency(\.myCarPullAPI) private var myCarPullAPI
    
    let fullCar = FullCar.shared
    
    var myCarPullList: [CarPull.Model.Information] = []
    
    init() {}
    
    func fetch() async {
        do {
            let value = try await myCarPullAPI.fetch()
            
            await MainActor.run {
                self.myCarPullList = value.data
            }
        } catch {
            print("error", error.localizedDescription)
        }
    }
}
