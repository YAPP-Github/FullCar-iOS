//
//  RequestOptions.swift
//  FullCarKit
//
//  Created by 한상진 on 12/17/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

public enum RetryResult {
    case retry
    case doNotRetry(with: Error)
}

public struct NetworkRequestOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let all: NetworkRequestOptions = [.refreshToken, .kickout, .forceUpdate]
    public static let none: NetworkRequestOptions = []
    public static let doNotRefreshToken: NetworkRequestOptions = [.kickout, .forceUpdate]
    public static let refreshToken = NetworkRequestOptions(rawValue: 1 << 0)
    public static let kickout = NetworkRequestOptions(rawValue: 1 << 1)
    public static let forceUpdate = NetworkRequestOptions(rawValue: 1 << 2)
}
