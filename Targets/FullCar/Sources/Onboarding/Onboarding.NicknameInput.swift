//
//  Onboarding.NicknameInput.swift
//  FullCar
//
//  Created by Sunny on 2/7/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

extension Onboarding.NicknameInput {
    @MainActor
    struct TextFieldView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            FCTextFieldView(
                textField: {
                    TextField("10자 이내로 입력해주세요.", text: $viewModel.nickname)
                        .textFieldStyle(.fullCar(
                            type: .check($viewModel.isNicknameValid),
                            state: $viewModel.nicknameTextFieldState)
                        )
                        .onChange(of: $viewModel.nickname.wrappedValue) { _, _ in
                            viewModel.updateNicknameValidation()
                            viewModel.resetNickname()
                        }
                },
                state: $viewModel.nicknameTextFieldState,
                headerText: "얍주식회사에 재직중인 회원님!\n뭐라고 불러드릴까요?",
                headerFont: .pretendard22(.bold),
                headerPadding: 20
            )
        }
    }

    @MainActor
    struct ButtonView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            Button(action: {
                Task {
                    await viewModel.sendVerificationNickname()
                }
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
            .disabled(!$viewModel.isNicknameButtonActive.wrappedValue)
        }
    }
}
