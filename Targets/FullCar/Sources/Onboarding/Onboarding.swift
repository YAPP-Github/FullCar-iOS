//
//  Onboarding.swift
//  FullCar
//
//  Created by Sunny on 1/25/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Dependencies

struct Onboarding {
    enum CompanySearch { }
    enum EmailInput { }
    enum NicknameInput { }
    enum GenderInput { }
}

extension Onboarding {
    enum Gender: String, CaseIterable {
        case female = "여성"
        case male = "남성"
        case notPublic = "공개안함"
        case none
    }
}

extension Onboarding {
    @MainActor
    @Observable
    final class ViewModel {
        @ObservationIgnored 
        @Dependency(\.memberService) private var memberService

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
        var isNicknameButtonActive: Bool = false

        var gender: Onboarding.Gender = .none

        var locations: [LocalCoordinate] = []
    }
}

// MARK: Email 관련 함수
extension Onboarding.ViewModel {
    /// Email 형식 유효성 검사 함수
    func updateEmailValidation() {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        isEmailButtonActive = emailPred.evaluate(with: email)
    }

    /// 본인확인 이메일 전송 api 호출
    func sendVerificationEmail() async {
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

    func resetEmailStatus() {
        isEmailValid = false
        emailTextFieldState = .default
        isEmailRequestSent = false
    }
}

// MARK: Nickname 관련 함수
extension Onboarding.ViewModel {
    /// Nickname 형식 유효성 검사 함수 - 2~10자, 한글/숫자/영문, 띄어쓰기불가
    func updateNicknameValidation() {
        let nicknamePattern = "^[가-힣A-Za-z0-9]{2,10}$"
        let nicknamePred = NSPredicate(format:"SELF MATCHES %@", nicknamePattern)
        isNicknameButtonActive = nicknamePred.evaluate(with: nickname)
    }

    /// 닉네임 중복 확인 api 호출
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

    func resetNickname() {
        isNicknameValid = false
        nicknameTextFieldState = .default
    }
}

// MARK: Company 관련 함수
extension Onboarding.ViewModel {
    /// 특정 검색어로 장소 리스트 검색
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
}

struct OnboardingView: View {
    @Bindable var viewModel: Onboarding.ViewModel

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
                Onboarding.EmailInput.TextFieldView(viewModel: viewModel)

                if $viewModel.isEmailValid.wrappedValue {
                    Onboarding.NicknameInput.TextFieldView(viewModel: viewModel)
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
            Onboarding.EmailInput.ButtonView(viewModel: viewModel)
        } else if !$viewModel.isNicknameValid.wrappedValue {
            Onboarding.NicknameInput.ButtonView(viewModel: viewModel)
        } else {
            completionButton
        }
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

    private var completionButton: some View {
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
