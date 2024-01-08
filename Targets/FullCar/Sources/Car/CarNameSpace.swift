//
//  CarNameSpace.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public struct Car {
    public struct Information {
        public let number: String
        public let model: String
        public let manufacturer: String
        public let color: String
        
        public init(number: String, model: String, manufacturer: String, color: String) {
            self.number = number
            self.model = model
            self.manufacturer = manufacturer
            self.color = color
        }
    }
}

#if DEBUG
public extension Car.Information {
    static var mock: Self = .init(number: "23루 2648", model: "아반떼", manufacturer: "현대자동차", color: "화이트")
}
#endif
