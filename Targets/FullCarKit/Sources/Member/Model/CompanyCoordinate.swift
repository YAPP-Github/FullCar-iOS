//
//  CompanyCoordinate.swift
//  FullCarKit
//
//  Created by Sunny on 2/5/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

struct CompanyCoordinate: Decodable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}
