//
//  CommonResponse.swift
//  FullCarKit
//
//  Created by 한상진 on 2/5/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public struct CommonResponse<T: Decodable>: Decodable {
    public let status: Int
    public let message: String
    public let data: T
    
    public init(status: Int, message: String, data: T) {
        self.status = status
        self.message = message
        self.data = data
    }
}
