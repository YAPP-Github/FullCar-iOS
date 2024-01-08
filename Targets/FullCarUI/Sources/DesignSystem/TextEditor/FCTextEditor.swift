//
//  FCTextEditor.swift
//  FullCarUI
//
//  Created by Sunny on 1/9/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct FCTextEditor<TextEditorView: View>: View {
    @ViewBuilder private let textEditorView: TextEditorView

    @FocusState private var isFocused: Bool
    @State private var state: InputState = .default
    @Binding private var text: String

    private let placeholder: String
    private var cornerRadius: CGFloat

    public var body: some View {
        ZStack(alignment: .topLeading) {
            textEditorView
                .font(pretendard: .semibold16)
                .focused($isFocused)
                .onChange(of: isFocused) { oldValue, newValue in
                    state = newValue ? .focus : .default
                }
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(state.borderColor, lineWidth: 1)
                )

            if text.isEmpty {
                placeholderView
            }
        }
    }

    private var placeholderView: some View {
        Text(placeholder)
            .font(pretendard: .semibold16)
            .foregroundStyle(Color.gray45)
            .onTapGesture {
                isFocused = true
            }
            .padding(Pretendard.Style.semibold16.lineHeightSize - 1)
            .padding(.vertical, 3)
    }
}

public extension FCTextEditor {
    init(
        @ViewBuilder textEditor: () -> TextEditorView,
        text: Binding<String>,
        placeholder: String,
        radius: CGFloat = 10
    ) {
        self.textEditorView = textEditor()
        self._text = text
        self.placeholder = placeholder
        self.cornerRadius = radius
    }
}

struct FCTextEditorModifierPreviews: PreviewProvider {
    @State static var text: String = ""
    @State static var text2: String = "안녕하세요. 예시 글 입니다."

    static var previews: some View {
        VStack {
            FCTextEditor(
                textEditor: {
                    TextEditor(text: $text)
                        .padding(16)
                },
                text: $text,
                placeholder: "placeholder 입니다."
            )

            FCTextEditor(
                textEditor: {
                    TextEditor(text: $text2)
                        .padding(16)
                },
                text: $text2,
                placeholder: "placeholder 입니다."
            )
        }
        .padding()
    }
}
