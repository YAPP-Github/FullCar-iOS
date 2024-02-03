//
//  CarNameSpace.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public struct Car {
    public struct Information: Decodable {
        let id: Int
        let carNumber: String
        let carName: String
        let carBrand: String
        let carColor: String
        
        init(
            id: Int,
            carNumber: String,
            carName: String,
            carBrand: String,
            carColor: String
        ) {
            self.id = id
            self.carNumber = carNumber
            self.carName = carName
            self.carBrand = carBrand
            self.carColor = carColor
        }
        
        private enum CodingKeys: String, CodingKey {
            case id
            case carNumber = "carNo"
            case carName
            case carBrand
            case carColor
        }
    }
}

#if DEBUG
public extension Car.Information {
    static var mock: Self = .init(
        id: .zero,
        carNumber: "23루 1234",
        carName: "펠리세이드",
        carBrand: "현대",
        carColor: "화이트"
    )
}
#endif
