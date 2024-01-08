//
//  Font+Custom.swift
//  FullCarUI
//
//  Created by Sunny on 12/27/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI

public protocol FontLineHeightConfigurable {
    var font: UIFont { get }
    var lineHeight: CGFloat { get }
}

struct FontWithLineHeight: ViewModifier {
    let fontConfigurable: FontLineHeightConfigurable

    func body(content: Content) -> some View {
        content
            .font(Font(fontConfigurable.font))
            .lineSpacing(fontConfigurable.lineHeight - fontConfigurable.font.lineHeight)
            .padding(.vertical, (fontConfigurable.lineHeight - fontConfigurable.font.lineHeight) / 2)
    }
}

extension View {
    public func font(pretendard: Pretendard.Style) -> some View {
        return modifier(FontWithLineHeight(fontConfigurable: pretendard as FontLineHeightConfigurable))
    }
}
