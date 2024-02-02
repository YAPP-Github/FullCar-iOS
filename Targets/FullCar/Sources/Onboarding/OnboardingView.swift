//
//  OnboardingView.swift
//  FullCar
//
//  Created by Sunny on 1/25/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

@MainActor
@Observable
final class OnboardingViewModel {
    func isEmailValid(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailPred.evaluate(with: email)
    }
}

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel

    @State private var email: String = ""
    @State private var emailTextFieldState: InputState = .default
    @State private var isEmailValid: Bool = false

    @State private var nickName: String = ""
    @State private var nickNameTextFieldState: InputState = .default
    @State private var isNickNameValid: Bool = false

    @State private var gender: Gender = .none

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: .zero) {
                bodyView

                Spacer()

                sendEmailButton
                    .padding(.bottom, 16)
                    .padding(.horizontal, 20)
                    .debug()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
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

    private var bodyView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                companyTextField

                if isEmailValid {
                    nickNameTextField
                }

                if isNickNameValid {
                    genderPicker
                }
            }
            .padding(.top, 32)
            .padding(.horizontal, 20)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
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
            SectionView(
                content: {
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
                },
                header: {
                    HeaderLabel(
                        title: "베스트드라이버님의 성별을 알려주세요.",
                        font: .pretendard22(.bold)
                    )
                }, 
                footer: {
                    if gender == .notPublic {
                        let notPublic: Message = .information("성별 미공개 시 게시글 노출률이 낮아질 수 있어요.")
                        Text(notPublic.description)
                            .font(.pretendard14(.semibold))
                            .foregroundStyle(notPublic.fontColor)
                    }
                },
                headerBottomPadding: 20,
                footerTopPadding: 8
            )
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
//            .disabled(viewModel.isEmailValid(<#T##email: String##String#>))
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
