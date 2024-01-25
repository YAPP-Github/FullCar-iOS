//
//  OnboardingView.swift
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

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel

    @State private var companyTextFieldState: InputState = .default

    @State var company: String = ""
    @State private var isSearchActive: Bool = false

    var body: some View {
        NavigationStack {
            bodyView
                .padding(.horizontal, 20)
                .padding(.top, 32)
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
                CompanySearchView(company: $company)
            }
        }
        .animation(.default, value: isSearchActive)
    }

    private var companyTextFieldView: some View {
        FCTextFieldView(
            textField: {
                TextField("회사, 주소 검색", text: $company)
                    .textFieldStyle(.fullCar(type: .search, state: $companyTextFieldState))

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
    OnboardingView(viewModel: .init())
}
