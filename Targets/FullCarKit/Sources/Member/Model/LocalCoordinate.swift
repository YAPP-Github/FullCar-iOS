//
//  LocalCoordinate.swift
//  FullCarKit
//
//  Created by Sunny on 2/5/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public struct LocalCoordinate: Decodable, Hashable {
    public var name: String
    public let address: String
    public let latitude: Double
    public let longitude: Double

    public init(
        name: String,
        address: String = "",
        latitude: Double = 0,
        longitude: Double = 0
    ) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
