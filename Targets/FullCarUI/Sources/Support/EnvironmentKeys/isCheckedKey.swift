//
//  isCheckedKey.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

struct IsCheckedKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isChecked: Bool {
        get { self[IsCheckedKey.self] }
        set { self[IsCheckedKey.self] = newValue }
    }
}

extension View {
    public func isChecked(_ checked: Bool) -> some View {
        environment(\.isChecked, checked)
    }
}
