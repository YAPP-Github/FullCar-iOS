//
//  CompanySearchView.swift
//  FullCar
//
//  Created by Sunny on 1/20/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

@MainActor
@Observable
final class OnboardingViewModel {

}

struct CompanySearchView: View {
    @Bindable var viewModel: OnboardingViewModel

    @State private var companyTextFieldState: InputState = .default
    @State private var companySearchBarState: InputState = .default

    @State var company: String = ""
    @State private var isSearchActive: Bool = false


    var body: some View {
        NavigationStack {
            bodyView
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 16)
                .navigationBarStyle(
                    leadingView: {
                        NavigationButton(icon: .back, action: { })
                    },
                    centerView: {
                        Text(isSearchActive ? "회사 입력" : "회원 가입")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: { }
                )
        }
    }

    private var bodyView: some View {
        ZStack(alignment: .top) {
            if !isSearchActive {
                companyTextFieldView
            } else {
                companySearchBar
            }
        }
        .animation(.default, value: isSearchActive)
    }

    private var companyTextFieldView: some View {
        VStack(spacing: .zero) {
            companyTextField

            Spacer()

            Button(action: {}, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
            .disabled(true)
        }
    }


    private var companyTextField: some View {
        FCTextFieldView(
            textField: {
                TextField("회사, 주소 검색", text: $company)
                    .textFieldStyle(.fullCar(
                        type: company.isEmpty ? .search : .check(.constant(true)),
                        state: $companyTextFieldState)
                    )
            },
            state: $companyTextFieldState,
            headerText: "안전한 카풀을 위해\n본인의 회사를 선택해 주세요.",
            headerFont: .pretendard22(.bold),
            headerPadding: 20
        )
        .onTapGesture {
            withAnimation {
                isSearchActive.toggle()
            }
        }
    }

    private var companySearchBar: some View {
        VStack {
            FCTextFieldView(
                textField: {
                    HStack {
                        TextField("회사, 주소 검색", text: $company)
                            .textFieldStyle(
                                .fullCar(
                                    type: .none,
                                    state: $companySearchBarState,
                                    padding: 16,
                                    backgroundColor: .gray5,
                                    cornerRadius: 10
                                ))

                        Button(action: {
                            print("검색 버튼 눌림")
                            companySearchBarState = .default
                        }, label: {
                            Text("검색")
                        })
                        .buttonStyle(.fullCar(
                            font: .pretendard16(.semibold),
                            horizontalPadding: 14,
                            verticalPadding: 15,
                            style: .palette(.primary_secondary)
                        ))
                    }
                },
                state: $companySearchBarState
            )

            Spacer()
        }
    }
}

#Preview {
    CompanySearchView(viewModel: .init())
}
