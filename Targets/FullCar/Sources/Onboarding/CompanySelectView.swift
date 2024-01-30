//
//  CompanySelectView.swift
//  FullCar
//
//  Created by Sunny on 1/30/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

struct CompanySelectView: View {
    @Bindable var viewModel: OnboardingViewModel

    @State var company: String = ""
    @State private var companyTextFieldState: InputState = .default
    @State private var isSearchActive: Bool = false

    var body: some View {
        NavigationStack {
            bodyView
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 16)
                .navigationBarStyle(
                    leadingView: { },
                    centerView: {
                        Text("회원 가입")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: { }
                )
                .navigationDestination(isPresented: $isSearchActive) {
                    CompanySearchView(viewModel: viewModel)
                }
        }
    }

    private var bodyView: some View {
        companyTextFieldView
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
}

#Preview {
    CompanySelectView(viewModel: .init())
}
