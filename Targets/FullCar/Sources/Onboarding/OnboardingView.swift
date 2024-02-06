//
//  OnboardingView.swift
//  FullCar
//
//  Created by Sunny on 1/25/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Dependencies

@MainActor
@Observable
final class OnboardingViewModel {
    @ObservationIgnored @Dependency(\.memberService) private var memberService

    var email: String = ""
    var emailTextFieldState: InputState = .default
    // 이메일 확인이 모두 완료되었을 때
    var isEmailValid: Bool = false
    // 블랙리스트 이메일인지 검증하는 api 호출 여부
    var isEmailRequestSent: Bool = false
    // "인증메일 발송" 버튼 활성화 여부
    var isEmailButtonActive: Bool = false

    var nickname: String = ""
    var nicknameTextFieldState: InputState = .default
    var isNicknameValid: Bool = false

    var gender: Onboarding.Gender = .none

    var locations: [LocalCoordinate] = []

    var member: MemberInformation? {
        didSet {
            print("멤버 변경됌. \(member)")
        }
    }

    func isEmailValid(_ email: String) {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        isEmailButtonActive = emailPred.evaluate(with: email)
    }

    // 이름...?
    func fetchCompanyCoordinate(_ company: String) async {
        // 실제 api가 호출되는 FullCarKit에는 api key에 접근할 수 없음. 따라서 FullCar에서 파라미터로 api key를 전달하는 방식이어야 하는데,, 괜춘할지?
        guard let kakaoRestApiKey = Bundle.main.kakaoRestApiKey else { return }

        do {
            let coordinates = try await memberService.searchLocation(company, kakaoRestApiKey)
            locations = coordinates
        } catch {
            print(error)
        }
    }

    func sendVerificationEmail() {
        // api 호출 이후 (response 오기 전)
        isEmailRequestSent = true
        isEmailButtonActive = false
        
        // response 온 이후
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // case1) 이메일 인증 성공
            self.isEmailValid = true
            self.emailTextFieldState = .default

            if false {
                // case2) 이메일 인증 실패
                self.isEmailValid = false
                self.emailTextFieldState = .error("일치하는 메일 정보가 없습니다.")
            }
        }
    }

    func sendVerificationNickname() async {
        do {
            // 닉네임 중복 확인 api 호출
            try await memberService.checkNickname(nickname)
            // case1) 닉네임 인증 성공
            isNicknameValid = true
            nicknameTextFieldState = .default
        } catch {
            print(error)
            isNicknameValid = false
            nicknameTextFieldState = .error("중복된 닉네임 입니다.")
        }
    }
}

struct Onboarding {
    enum Gender: String, CaseIterable {
        case female = "여성"
        case male = "남성"
        case notPublic = "공개안함"
        case none
    }
}

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: .zero) {
                bodyView

                Spacer()

                buttonView
                    .padding(.bottom, 16)
                    .padding(.horizontal, 20)
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

                if $viewModel.isEmailValid.wrappedValue {
                    nicknameTextField
                }

                if $viewModel.isNicknameValid.wrappedValue {
                    genderPicker
                }
            }
            .padding(.top, 32)
            .padding(.horizontal, 20)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private var buttonView: some View {
        if !$viewModel.isEmailValid.wrappedValue {
            sendEmailButton
        } else if !$viewModel.isNicknameValid.wrappedValue {
            nicknameButton
        } else {
            genderButton
        }
    }

    private var companyTextField: some View {
        FCTextFieldView(
            textField: {
                TextField("\("gildong@fullcar.com")", text: $viewModel.email)
                    .textFieldStyle(.fullCar(
                        type: .check($viewModel.isEmailValid),
                        state: $viewModel.emailTextFieldState)
                    )
                    .onChange(of: $viewModel.email.wrappedValue) { _, newValue in
                        // email textField 입력할 때마다 이메일 유효성 검사
                        Task {
                            await viewModel.isEmailValid(newValue)
                        }

                        // MARK: text field 수정할 때마다 state 변경되어야 함.
                    }
            },
            state: $viewModel.emailTextFieldState,
            headerText: "회사 메일을 입력해 주세요.",
            headerFont: .pretendard22(.bold),
            headerPadding: 20
        )
    }

    private var nicknameTextField: some View {
        FCTextFieldView(
            textField: {
                TextField("10자 이내로 입력해주세요.", text: $viewModel.nickname)
                    .textFieldStyle(.fullCar(
                        type: .check($viewModel.isNicknameValid),
                        state: $viewModel.nicknameTextFieldState)
                    )
                    .onChange(of: $viewModel.nickname.wrappedValue) { _, _ in
                        $viewModel.nicknameTextFieldState.wrappedValue = .default
                    }
            },
            state: $viewModel.nicknameTextFieldState,
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
                        ForEach(Onboarding.Gender.allCases, id: \.self) { genderType in
                            if genderType != .none {
                                Button(action: {
                                    $viewModel.gender.wrappedValue = genderType
                                }, label: {
                                    Text(genderType.rawValue)
                                })
                                .buttonStyle(.chip(genderType == $viewModel.gender.wrappedValue))
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
                    if $viewModel.gender.wrappedValue == .notPublic {
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
            if $viewModel.isEmailRequestSent.wrappedValue {
                Text("메일이 오지 않나요? >")
                    .foregroundStyle(Color.fullCar_primary)
                    .font(.pretendard14(.semibold))
            }

            Button(action: {
                Task {
                    await viewModel.sendVerificationEmail()
                    // MARK: 닉네임 textField로 포커스 변경하고 싶은데,,
                }
            }, label: {
                Text("인증메일 발송")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
            .disabled(!$viewModel.isEmailButtonActive.wrappedValue)
        }
    }

    private var nicknameButton: some View {
        Button(action: {
            Task {
                await viewModel.sendVerificationNickname()
            }
        }, label: {
            Text("다음")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.fullCar(style: .palette(.primary_white)))
    }

    private var genderButton: some View {
        Button(action: {
            // 온보딩 완료!
        }, label: {
            Text("완료")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.fullCar(style: .palette(.primary_white)))
    }
}

#Preview {
    OnboardingView(viewModel: .init())
}
