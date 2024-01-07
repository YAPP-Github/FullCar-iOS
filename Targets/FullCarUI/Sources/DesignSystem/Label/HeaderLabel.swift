//
//  FullCarText.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// Header에 위치하는 Label입니다. 필수적으로 입력해야 하는  Content가 존재하는 경우, isRequired 속성을 true로 설정합니다.
public struct HeaderLabel: View {
    private let value: String
    private let isRequired: Bool
    private let font: Pretendard.Style

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

public extension HeaderLabel {
    init(
        title: String,
        isRequired: Bool = false,
        font: Pretendard.Style = .body4
    ) {
        self.value = title
        self.isRequired = isRequired
        self.font = font
    }
}

#Preview {
    HeaderLabel(
        title: "희망 접선 장소",
        isRequired: true,
        font: .body4
    )
}
