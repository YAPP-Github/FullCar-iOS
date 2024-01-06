//
//  FullCarTextField.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// Header, TextField, Footer로 구성되어있는 View입니다. Footer는 Message 타입으로 error, information 등의 정보를 나타냅니다.
public struct FullCarTextField<TextField: View>: View {
    @ViewBuilder private let textField: TextField
    @FocusState private var isFocused: Bool
    @Binding private var state: InputState

    /// header 관련 속성
    private let headerText: String?
    private let isHeaderRequired: Bool
    private let headerFont: Pretendard.Style
    private let headerBottomPadding: CGFloat
    /// footer 관련 속성
    private let footerMessage: Message?

    public var body: some View {
        SectionView(
            content: {
                textField
            },
            header: {
                if let headerText = headerText {
                    HeaderLabel(
                        title: headerText,
                        isRequired: isHeaderRequired,
                        font: headerFont
                    )
                }
            },
            footer: {
                /// 에러 상태일 때, 에러 메세지 띄우는 경우
                if case .error(let errorMessage) = state {
                    MessageLabel(.error(errorMessage))
                }

                /// 안내 문구 띄우는 경우
                if case .information(let description, _) = footerMessage {
                    MessageLabel(.information(description))
                }
            },
            headerBottomPadding: headerBottomPadding,
            footerTopPadding: footerTopPadding
        )
    }

    private var footerTopPadding: CGFloat {
        switch state {
        case .default, .focus: return 10
        case .error: return 8
        }
    }
}

public extension FullCarTextField {
    init(
        @ViewBuilder textField: () -> TextField,
        state: Binding<InputState>,
        headerText: String? = nil,
        isHeaderRequired: Bool = false,
        headerFont: Pretendard.Style = .body4,
        headerPadding: CGFloat = 12,
        footerMessage: Message? = nil
    ) {
        self.textField = textField()
        self._state = state
        self.headerText = headerText
        self.isHeaderRequired = isHeaderRequired
        self.headerFont = headerFont
        self.headerBottomPadding = headerPadding
        self.footerMessage = footerMessage
    }
}

struct FullCarTextFieldPreviews: PreviewProvider {
    @State static var text: String = ""
    @State static var inputState: InputState = .default

    @State static var isChecked: Bool = true
    @State static var isChecked_false: Bool = false

    @State static var inputState_error: InputState = .error("일치하는 메일 정보가 없습니다.\n회사 메일이 없는 경우 명함으로 인증하기를 이용해 주세요!")

    static var previews: some View {
        VStack(spacing: 30) {
            FullCarTextField(
                textField: {
                    TextField("회사, 주소 검색", text: $text)
                        .textFieldStyle(.check(isChecked: $isChecked, borderColor: inputState.borderColor))
                },
                state: $inputState,
                headerText: "회사 입력",
                isHeaderRequired: true,
                headerPadding: 5
            )

            FullCarTextField(
                textField: {
                    TextField("Placeholder", text: $text)
                        .textFieldStyle(.check(isChecked: $isChecked_false, borderColor: inputState_error.borderColor))
                },
                state: $inputState_error
            )

            FullCarTextField(
                textField: {
                    TextField("Placeholder", text: $text)
                        .textFieldStyle(.check(isChecked: $isChecked_false, borderColor: inputState.borderColor))
                },
                state: $inputState,
                footerMessage: .information("이건 정보성 메세지에요.")
            )
        }
        .padding()
    }
}
