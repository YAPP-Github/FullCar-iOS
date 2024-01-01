//
//  MessageLabel.swift
//  FullCarUI
//
//  Created by Sunny on 1/2/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 가로 정렬의 "메세지 + 아이콘"
public struct MessageLabel: View {
    private let message: Message?
    private let spacing: CGFloat
    private let lineSpacing: CGFloat

    private let iconSize: CGFloat = 20

    public init(
        _ message: Message?,
        spacing: CGFloat = 4,
        lineSpacing: CGFloat = 4
    ) {
        self.message = message
        self.spacing = spacing
        self.lineSpacing = lineSpacing
    }

    public var body: some View {
        if let message = message {
            HStack(alignment: .firstTextBaseline, spacing: spacing) {
                if let icon = message.icon, let image = icon.image {
                    image
                        .frame(width: iconSize)
                }
                Text(message.description)
                    .lineSpacing(lineSpacing)
                    .font(pretendard: .caption1)
            }
            .foregroundStyle(message.color)
        }
    }
}

struct FieldMessagePreviews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MessageLabel(.information("안내 메세지입니다."))
            
            MessageLabel(.error("에러 메세지입니다."))
        }
    }
}
