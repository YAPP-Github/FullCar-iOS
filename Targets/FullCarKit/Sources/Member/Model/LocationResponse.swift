//
//  LocationResponse.swift
//  FullCarKit
//
//  Created by Sunny on 2/5/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

struct LocationResponse: Decodable {
    let locations: [Location]

    enum CodingKeys: String, CodingKey {
        case locations = "documents"
    }
}

struct Location: Decodable {
    let placeName: String
    let roadAddressName: String
    let x: String
    let y: String

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case roadAddressName = "road_address_name"
        case x, y
    }
}
