//
//  OnboardingView.swift
//  FullCar
//
//  Created by Sunny on 1/25/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel

    @State private var email: String = ""
    @State private var emailTextFieldState: InputState = .default
    @State private var isEmailValid: Bool = true

    @State private var nickName: String = ""
    @State private var nickNameTextFieldState: InputState = .default
    @State private var isNickNameValid: Bool = true

    @State private var gender: Gender = .none

    var body: some View {
        bodyView
    }

    private var bodyView: some View {
        ScrollView {
            VStack(spacing: .zero) {
                VStack(alignment: .leading, spacing: 40) {
                    companyTextField

                    if isEmailValid {
                        nickNameTextField
                    }

                    if isNickNameValid {
                        genderPicker
                    }
                }

                Spacer()

                sendEmailButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            .padding(.bottom, 46)
        }
        .navigationBarStyle(
            leadingView: {
                NavigationButton(icon: .back, action: { })
            },
            centerView: {
                Text("회원 가입")
                    .font(.pretendard18(.bold))
            },
            trailingView: { }
        )
    }

    private var companyTextField: some View {
        FCTextFieldView(
            textField: {
                TextField("gildong@fullcar.com3", text: $email)
                    .textFieldStyle(.fullCar(
                        type: .check($isEmailValid),
                        state: $emailTextFieldState)
                    )
            },
            state: $emailTextFieldState,
            headerText: "회사 메일을 입력해 주세요.",
            headerFont: .pretendard22(.bold),
            headerPadding: 20
        )
    }

    private var nickNameTextField: some View {
        FCTextFieldView(
            textField: {
                TextField("10자 이내로 입력해주세요.", text: $nickName)
                    .textFieldStyle(.fullCar(
                        type: .check($isNickNameValid),
                        state: $nickNameTextFieldState)
                    )
            },
            state: $nickNameTextFieldState,
            headerText: "얍주식회사에 재직중인 회원님!\n뭐라고 불러드릴까요?",
            headerFont: .pretendard22(.bold),
            headerPadding: 20
        )
    }

    private var genderPicker: some View {
        VStack(alignment: .leading, spacing: 20) {
            HeaderLabel(
                title: "베스트드라이버는나야 님의 성별을 알려주세요.",
                font: .pretendard22(.bold)
            )

            HStack(spacing: 6) {
                ForEach(Gender.allCases, id: \.self) { genderType in
                    if genderType != .none {
                        Button(action: {
                            gender = genderType
                        }, label: {
                            Text(genderType.rawValue)
                        })
                        .buttonStyle(.chip(genderType == gender))
                    }
                }
            }
        }
    }

    private var sendEmailButton: some View {
        VStack(spacing: 10) {
            Text("메일이 오지 않나요? >")
                .foregroundStyle(Color.fullCar_primary)
                .font(.pretendard14(.semibold))
                // 인증메일 발송 api 전송 이후 appear
                .hidden()

            Button(action: {}, label: {
                Text("인증메일 발송")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
            .disabled(true)
        }
    }
}

extension OnboardingView {
    enum Gender: String, CaseIterable {
        case female = "여성"
        case male = "남성"
        case notPublic = "공개안함"
        case none
    }
}

#Preview {
    OnboardingView(viewModel: .init())
}
