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
    enum Company { }
    enum Email { }
    enum Nickname { }
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
        @Dependency(\.onbardingAPI) private var onboardingAPI

        // MARK: Company Input
        var company: LocalCoordinate?

        // MARK: CompanySearch
        var companySearchBarState: InputState = .default

        // MARK: 화면 이동
        var isSearchViewAppear: Bool = false
        var isOnboardingViewAppear: Bool = false

        // MARK: Email
        var email: String = ""
        var emailTextFieldState: InputState = .default
        // 블랙리스트 이메일인지 검증하는 api 호출 여부
        var isEmailRequestSent: Bool = false
        // 이메일 블랙리스트 확인 완료
        var isEmailAddressValid: Bool = false
        // 회사 이메일 인증 절차 모두 완료
        var isEmailValid: Bool = false

        // MARK: Nickname
        var nickname: String = ""
        var nicknameTextFieldState: InputState = .default
        var isNicknameValid: Bool = false
        var isNicknameButtonActive: Bool = false

        // MARK: Gender
        var gender: Onboarding.Gender = .none
    }
}

// MARK: Email 관련 함수
extension Onboarding.ViewModel {
    /// Email 형식 유효성 검사 함수
    func isEmailValidation() -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailPred.evaluate(with: email)
    }

    /// 본인확인 이메일 전송 api 호출
    func sendEmail() async {
        do {
            isEmailRequestSent = true
            emailTextFieldState = .default

            try await onboardingAPI.send(email: email)

            isEmailAddressValid = true
        } catch {
            // 이메일 전송 실패
            print(error)
            isEmailRequestSent = false
            emailTextFieldState = .error("일치하는 메일 정보가 없습니다.")

            isEmailAddressValid = false
        }
    }

    func checkAuthenticationNumber() async {
//        do {
//
//        } catch {
//            print(error)
//        }

        // case1) 이메일 인증 성공
        self.isEmailValid = true

        if false {
            // case2) 이메일 인증 실패
            self.isEmailValid = false
        }
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
            try await onboardingAPI.check(nickname: nickname)
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
    func fetchCompanyCoordinate(_ company: String) async -> [LocalCoordinate] {
        do {
            let coordinates = try await onboardingAPI.search(location: company)
            return coordinates
        } catch {
            print(error)
            return []
        }
    }
}

extension Onboarding {
    @MainActor
    struct BodyView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            NavigationStack {
                VStack(spacing: .zero) {
                    bodyView

                    Spacer()

                    buttonView
                        .padding(.bottom, 16)
                        .padding(.horizontal, 20)
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
        }

        private var bodyView: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    Onboarding.Email.TextFieldView(viewModel: viewModel)

                    if viewModel.isEmailAddressValid {
                        Onboarding.Email.NumberView(viewModel: viewModel)
                    }

                    if viewModel.isEmailValid {
                        Onboarding.Nickname.TextFieldView(viewModel: viewModel)
                    }

                    if viewModel.isNicknameValid {
                        Onboarding.Gender.PickerView(viewModel: viewModel)
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
            if !viewModel.isEmailAddressValid {
                Onboarding.Email.SendButtonView(viewModel: viewModel)
            } else if !viewModel.isEmailValid {
                Onboarding.Email.CertificationButtonView(viewModel: viewModel)
            } else if !viewModel.isNicknameValid {
                Onboarding.Nickname.ButtonView(viewModel: viewModel)
            } else {
                Onboarding.Gender.ButtonView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    Onboarding.BodyView(viewModel: .init())
}