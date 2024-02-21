//
//  Onboarding.Email.swift
//  FullCar
//
//  Created by Sunny on 2/7/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

extension Onboarding.Email {
    @MainActor
    struct TextFieldView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        @FocusState private var isFocused: Onboarding.Field?

        var body: some View {
            bodyView
                .onAppear {
                    isFocused = .email
                }
                .onChange(of: isFocused) { _, newValue in
                    viewModel.isFocused = newValue
                }
        }

        private var bodyView: some View {
            FCTextFieldView(
                textField: {
                    TextField("\("gildong@fullcar.com")", text: $viewModel.email)
                        .focused($isFocused, equals: .email)
                        .textFieldStyle(.fullCar(
                            type: .check($viewModel.isEmailValid),
                            state: $viewModel.emailTextFieldState)
                        )
                        .onChange(of: viewModel.email) {
                            viewModel.isEmailRequestSent = false
                            viewModel.isEmailAddressValid = false
                        }
                        .disabled(viewModel.isEmailValid)
                        .keyboardType(.emailAddress)
                },
                state: $viewModel.emailTextFieldState,
                headerText: "회사 메일을 입력해 주세요.",
                headerFont: .pretendard22(.bold),
                headerPadding: 20
            )
        }
    }

    @MainActor
    struct AuthCodeView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        @FocusState private var isFocused: Onboarding.Field?

        var body: some View {
            bodyView
                .onAppear {
                    isFocused = .authCode
                }
                .onChange(of: isFocused) { _, newValue in
                    viewModel.isFocused = newValue
                }
        }

        private var bodyView: some View {
            FCTextFieldView(
                textField: {
                    TextField("인증번호 6자리를 입력해 주세요.",
                              text: $viewModel.authenticationCode)
                    .focused($isFocused, equals: .authCode)
                    .textFieldStyle(.fullCar(
                        state: $viewModel.authCodeTextFieldState,
                        padding: 16)
                    )
                    .keyboardType(.numberPad)
                },
                state: $viewModel.authCodeTextFieldState
            )
        }
    }

    @MainActor
    struct SendButtonView: View {
        @Environment(\.openURL) var openURL
        
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            VStack(spacing: 10) {
                if viewModel.isEmailRequestSent {
                    guideButton
                }

                Button(action: {
                    Task {
                        await viewModel.sendEmail()
                    }
                }, label: {
                    Text("인증메일 발송")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.fullCar(style: .palette(.primary_white)))
                .disabled(!viewModel.isEmailValidation() == !viewModel.isEmailRequestSent)
            }
        }

        private var guideButton: some View {
            Button(action: {
                let url = URL(string: "https://open.kakao.com/o/sg3bvqag")
                openURL(url!)
            }, label: {
                Text("메일이 오지 않나요? >")
                    .foregroundStyle(Color.fullCar_primary)
                    .font(.pretendard14(.semibold))
            })
        }
    }

    @MainActor
    struct CertificationButtonView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            Button(action: {
                Task {
                    await viewModel.verifyAuthenticationCode()
                }
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        Onboarding.Email.TextFieldView(viewModel: .init())

        Onboarding.Email.AuthCodeView(viewModel: .init())

        Onboarding.Email.SendButtonView(viewModel: .init())
    }
}
#endif
