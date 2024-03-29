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
    enum Nickname { 
        static let id = "nickName"
    }
    enum Gender: String, CaseIterable {
        case female = "FEMALE"
        case male = "MALE"
        case notPublic = "NONE"
        case notSelect

        var title: String {
            switch self {
            case .female: return "여성"
            case .male: return "남성"
            case .notPublic: return "공개안함"
            case .notSelect: return ""
            }
        }
    }

    enum Field: Hashable {
        case company
        case email
        case authCode
        case nickname
    }
}

extension Onboarding {
    @MainActor
    @Observable
    final class ViewModel {
        @ObservationIgnored 
        @Dependency(\.onbardingAPI) private var onboardingAPI

        let fullCar = FullCar.shared

        var isFocused: Onboarding.Field?

        // MARK: 화면 이동
        var isSearchViewAppear: Bool = false
        var isOnboardingViewAppear: Bool = false

        // MARK: Company
        var company: LocalCoordinate?
        var companySearchBarState: InputState = .default
        var isCompanyValid: Bool = false

        // MARK: Email
        var email: String = ""
        var emailTextFieldState: InputState = .default
        // 블랙리스트 이메일인지 검증하는 api 호출 여부
        var isEmailRequestSent: Bool = false
        // 이메일 블랙리스트 확인 완료
        var isEmailAddressValid: Bool = false
        // 인증번호
        var authenticationCode: String = ""
        var authCodeTextFieldState: InputState = .default
        // 회사 이메일 인증 절차 모두 완료
        var isEmailValid: Bool = false

        // MARK: Nickname
        var nickname: String = ""
        var nicknameTextFieldState: InputState = .default
        var isNicknameValid: Bool = false

        // MARK: Gender
        var gender: Onboarding.Gender = .notSelect
    }
}

// MARK: Company 관련 함수
extension Onboarding.ViewModel {
    /// 특정 검색어로 장소 리스트 검색
    func fetchCompanyCoordinate(_ company: String) async -> [LocalCoordinate] {
        do {
            let coordinates = try await onboardingAPI.search(location: company)
            companySearchBarState = .default

            return coordinates
        } catch {
            print(error)

            return []
        }
    }

    func onTappedLocation(_ location: LocalCoordinate) {
        company = location
        isCompanyValid = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.isSearchViewAppear = false
        }
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
            print(error)
            isEmailRequestSent = false
            emailTextFieldState = .error("회사 이메일이 맞는지 확인해 주세요.")

            isEmailAddressValid = false
        }
    }

    func verifyAuthenticationCode() async {
        do {
            try await onboardingAPI.verify(code: authenticationCode)

            isEmailValid = true
        } catch {
            print(error)

            isEmailValid = false
            authCodeTextFieldState = .error("인증번호가 일치하지 않습니다.")
        }
    }
}

// MARK: Nickname 관련 함수
extension Onboarding.ViewModel {
    /// Nickname 형식 유효성 검사 함수 - 2~10자, 한글/숫자/영문, 띄어쓰기불가
    func isNicknameValidation() -> Bool {
        let nicknamePattern = "^[가-힣A-Za-z0-9]{2,10}$"
        let nicknamePred = NSPredicate(format:"SELF MATCHES %@", nicknamePattern)
        return nicknamePred.evaluate(with: nickname)
    }

    /// 닉네임 중복 확인 api 호출
    func sendVerificationNickname() async {
        isFocused = nil

        do {
            try await onboardingAPI.check(nickname: nickname)

            isNicknameValid = true
            nicknameTextFieldState = .default
        } catch {
            print(error)
            isNicknameValid = false
            nicknameTextFieldState = .error("중복된 닉네임 입니다.")
        }
    }
}

// MARK: 그외 Onboarding 관련 함수
extension Onboarding.ViewModel {
    func register() async {
        do {
            guard let company = company else { return }
            let newMember: MemberInformation = .init(
                company: company,
                email: email,
                nickName: nickname,
                gender: gender.rawValue
            )
            let member = try await onboardingAPI.register(member: newMember)

            completeOnboarding(member)
        } catch {
            print(error)
        }
    }

    func onAppear() {
        email = ""
        emailTextFieldState = .default

        nickname = ""
        nicknameTextFieldState = .default

        gender = .notSelect
    }

    func onBackButtonTapped() {
        fullCar.appState = .login
    }

    func completeOnboarding(_ member: MemberInformation) {
        fullCar.appState = .tab(member)
    }
}

extension Onboarding {
    @MainActor
    struct BodyView: View {
        @Environment(\.dismiss) private var dismiss
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            NavigationStack {
                bodyView
                    .onAppear {
                        viewModel.onAppear()
                    }
                    .navigationBarStyle(
                        leadingView: {
                            NavigationButton(icon: .back, action: { dismiss() })
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
            VStack(spacing: .zero) {
                inputView

                Spacer()

                buttonView
                    .padding(.horizontal, 20)
            }
        }

        private var inputView: some View {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        VStack(spacing: 16) {
                            Onboarding.Email.TextFieldView(viewModel: viewModel)

                            if viewModel.isEmailAddressValid && !viewModel.isEmailValid {
                                Onboarding.Email.AuthCodeView(viewModel: viewModel)
                            }
                        }

                        if viewModel.isEmailValid {
                            Onboarding.Nickname.TextFieldView(viewModel: viewModel)
                                .id(Onboarding.Nickname.id)
                                .onChange(of: viewModel.nicknameTextFieldState) { _, newValue in
                                    if newValue == .focus {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                                            withAnimation {
                                                proxy.scrollTo(Onboarding.Nickname.id, anchor: .top)
                                            }
                                        }
                                    }
                                }
                        }

                        if viewModel.isNicknameValid {
                            Onboarding.Gender.PickerView(viewModel: viewModel)
                        }

                        Spacer()
                            .frame(height: 80)
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 20)
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollIndicators(.hidden)
            }
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

#if DEBUG
#Preview {
    Onboarding.BodyView(viewModel: .init())
}
#endif
