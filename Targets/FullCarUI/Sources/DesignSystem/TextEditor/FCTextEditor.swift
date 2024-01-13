//
//  FCTextEditor.swift
//  FullCarUI
//
//  Created by Sunny on 1/9/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct FCTextEditor: View {
    @FocusState private var isFocused: Bool
    @Binding private var text: String
    @State private var state: InputState = .default

    private let placeholder: String
    private let font: Pretendard.Style
    private let padding: CGFloat
    private var cornerRadius: CGFloat

    public var body: some View {
        ZStack(alignment: .topLeading) {
            textEditor

            if text.isEmpty {
                placeholderView
            }
        }
    }

    private var textEditor: some View {
        TextEditor(text: $text)
            .font(font)
            .padding(padding)
            .focused($isFocused)
            .onChange(of: isFocused) { oldValue, newValue in
                state = newValue ? .focus : .default
            }
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(state.borderColor, lineWidth: 1)
            )
    }

    private var placeholderView: some View {
        Text(placeholder)
            .font(font)
            .foregroundStyle(Color.gray45)
            .onTapGesture {
                isFocused = true
            }
            .padding(padding)
            .padding(.horizontal, Constants.placeholderHorizontal)
            .padding(.vertical, Constants.placeholderVertical)
    }
}

public extension FCTextEditor {
    init(
        text: Binding<String>,
        placeholder: String,
        font: Pretendard.Style = .pretendard16(.semibold),
        padding: CGFloat = 16,
        radius: CGFloat = 10
    ) {
        self._text = text
        self.placeholder = placeholder
        self.padding = padding
        self.font = font
        self.cornerRadius = radius
    }

    enum Constants {
        static let placeholderHorizontal: CGFloat = 5
        static let placeholderVertical: CGFloat = 8
    }
}

struct FCTextEditorModifierPreviews: PreviewProvider {
    @State static var text: String = ""
    @State static var text2: String = "안녕하세요. 예시 글 입니다"

    static var previews: some View {
        VStack {
            FCTextEditor(
                text: $text,
                placeholder: "placeholder 입니다."
            )

            FCTextEditor(
                text: $text2,
                placeholder: "안녕하세요. 예시 글 입니다"
            )
        }
        .padding()
    }
}
