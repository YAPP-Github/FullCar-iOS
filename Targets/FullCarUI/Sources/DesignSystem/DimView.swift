//
//  DimView.swift
//  FullCarUI
//
//  Created by Sunny on 2/20/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct DimView: View {
    private let color: Color
    private let scale: CGFloat

    public init(color: Color, scale: CGFloat) {
        self.color = color
        self.scale = scale
    }

    public var body: some View {
        bodyView
    }

    private var bodyView: some View {
        ProgressView().id(UUID())
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .scaleEffect(scale)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    DimView(color: .fullCar_primary, scale: 1.3)
}
