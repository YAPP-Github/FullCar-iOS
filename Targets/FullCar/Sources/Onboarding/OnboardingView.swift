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
    let viewModel: OnboardingViewModel

    @State private var companyTextFieldState: InputState = .default

    @State var company: String = ""
    @State private var isSearchActive: Bool = false

    var body: some View {
        bodyView
    }

    private var bodyView: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                if !isSearchActive {
                    companyTextFieldView
                        .padding(.horizontal, 20)
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
                } else {
                    CompanySearchView(company: $company)
                        .padding(.horizontal, 20)
                        .transition(.move(edge: .bottom))
                }
            }
        }
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
        .onChange(of: companyTextFieldState) { oldValue, newValue in
            if newValue == .focus {
                withAnimation {
                    isSearchActive.toggle()
                }
            }
        }
    }
}

#Preview {
    OnboardingView(viewModel: .init())
}
