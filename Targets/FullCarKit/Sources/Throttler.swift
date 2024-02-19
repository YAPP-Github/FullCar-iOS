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
    private var isWaiting: Bool = false

    public init(duration: TimeInterval) {
        self.duration = UInt64(duration * 1_000_000_000)
    }

    public func call(_ task: @escaping () async -> Void) {
        Task {
            await execute(task: task)
        }
    }

    private func execute(task: @escaping () async -> Void) async {
        guard !isWaiting else { return }
        isWaiting = true

        await task()

        try? await Task.sleep(nanoseconds: duration)
        isWaiting = false
    }
}
