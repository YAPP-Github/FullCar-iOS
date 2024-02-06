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

    var locations: [LocalCoordinate] = []

    var member: MemberInformation? {
        didSet {
            print("멤버 변경됌. \(member)")
        }
    }

    func isEmailValid(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailPred.evaluate(with: email)
    }

    // 이름...?
    func fetchCompanyCoordinate(_ company: String) async {
        guard let kakaoRestApiKey = Bundle.main.kakaoRestApiKey else { return }

        // location search 실행
        do {
            let coordinates = try await memberService.locationSearch(company, kakaoRestApiKey)
            locations = coordinates
        } catch {
            print(error)
        }
    }

    func sendVerificationEmail(_ address: String) -> Bool {
        sleep(2)
        return true
    }

    func sendVerificationNickname(_ nickname: String) -> Bool {
        sleep(2)
        return true
    }
}

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel

    @State private var email: String = ""
    @State private var emailTextFieldState: InputState = .default
    @State private var isEmailValid: Bool = false
    // 블랙리스트 이메일인지 검증하는 api 호출 여부
    @State private var isEmailRequestSent: Bool = false

    @State private var nickname: String = ""
    @State private var nicknameTextFieldState: InputState = .default
    @State private var isNicknameValid: Bool = false

    @State private var gender: Gender = .none

    @State private var isEmailButtonActive: Bool = false

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

                if isEmailValid {
                    nicknameTextField
                }

                if isNicknameValid {
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
        if !isEmailValid {
            sendEmailButton
        } else if !isNicknameValid {
            nicknameButton
        } else {
            genderButton
        }
    }

    private var companyTextField: some View {
        FCTextFieldView(
            textField: {
                TextField("\("gildong@fullcar.com")", text: $email)
                    .textFieldStyle(.fullCar(
                        type: .check($isEmailValid),
                        state: $emailTextFieldState)
                    )
                    .onChange(of: email) { oldValue, newValue in
                        Task {
                            isEmailButtonActive = await viewModel.isEmailValid(newValue)
                        }
                    }
            },
            state: $emailTextFieldState,
            headerText: "회사 메일을 입력해 주세요.",
            headerFont: .pretendard22(.bold),
            headerPadding: 20
        )
    }

    private var nicknameTextField: some View {
        FCTextFieldView(
            textField: {
                TextField("10자 이내로 입력해주세요.", text: $nickname)
                    .textFieldStyle(.fullCar(
                        type: .check($isNicknameValid),
                        state: $nicknameTextFieldState)
                    )
            },
            state: $nicknameTextFieldState,
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
            if isEmailRequestSent {
                Text("메일이 오지 않나요? >")
                    .foregroundStyle(Color.fullCar_primary)
                    .font(.pretendard14(.semibold))
            }

            Button(action: {
                // email 블랙리스트 여부 api 호출
                isEmailRequestSent = true
                isEmailButtonActive = false

                Task {
                    if await viewModel.sendVerificationEmail(email) {
                        // api response에 따라 Button 활성, 비활성 여부
                        isEmailValid = true
                        // 회사 메일이 인증 완료되었음으로, emailTextFieldState 변경
                        // 닉네임 textField로 포커스 변경하고 싶은데,,
                        emailTextFieldState = .default
                    }
                }
                // api response success -> 인증메일 발송 버튼 대신 "다음" 버튼 + 닉네임 textfield 생성
                // api response fail -> emailTextFieldState = .error로 변경
                    // 그 후 email이 한자로도 변경되면 해당 버튼 active 활성화
            }, label: {
                Text("인증메일 발송")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
            .disabled(!isEmailButtonActive)
        }
    }

    private var nicknameButton: some View {
        Button(action: {
            Task {
                if await viewModel.sendVerificationNickname(nickname) {
                    // 닉네임 유효성 검사가 통과할 경우,
                    isNicknameValid = true
                    nicknameTextFieldState = .default
                }
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
