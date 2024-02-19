//
//  Throttler.swift
//  FullCarKit
//
//  Created by Sunny on 2/19/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

public actor Throttler {
    private let duration: UInt64
    private var task: Task<Void, Never>?
    private var isCancelled: Bool = false

    public init(duration: TimeInterval) {
        self.duration = UInt64(duration * 1_000_000_000)
    }

    public func execute(_ task: @escaping () async -> Void) {
        guard self.task?.isCancelled ?? true else { return }

        Task {
            await task()
        }

        self.task = Task {
            try? await Task.sleep(nanoseconds: duration)
            self.task?.cancel()
            self.task = nil
        }
    }
}
