//
//  FullCarText.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// SectionView의 Header에 들어가는 HeaderLabel
public struct HeaderLabel: View {
    private let value: String
    private let isRequired: Bool
    private let font: Pretendard.Style

    init(
        value: String,
        isRequired: Bool,
        font: Pretendard.Style = .body4
    ) {
        self.value = value
        self.isRequired = isRequired
        self.font = font
    }

    public var body: some View {
        HStack(spacing: 0) {
            Text(value)
                .font(pretendard: font)

            if isRequired {
                Text(" *")
                    .font(pretendard: font)
                    .foregroundStyle(Color.red100)
            }
        }
    }
}

#Preview {
    HeaderLabel(
        value: "희망 접선 장소",
        isRequired: true,
        font: .body4
    )
}
