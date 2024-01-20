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

    @State var companyTextFieldState: InputState = .default
    @State var company: String = ""

    var body: some View {
        bodyView
    }

    private var bodyView: some View {
        ScrollView {
            VStack {
                companyEnterView
            }
            .padding(.horizontal, 20)
            .navigationBarStyle(
                leadingView: {
                    NavigationButton(icon: .back, action: { })
                },
                centerView: {
                    
                },
                trailingView: {

                }
            )
        }
    }

    private var companyEnterView: some View {
        VStack {
            FCTextFieldView(
                textField: {
                    if companyTextFieldState == .focus {
                        HStack {
                            TextField("회사, 주소 검색", text: $company)
                                .textFieldStyle(.fullCar(type: .none(14), state: $companyTextFieldState))

                            Button(action: {}, label: {
                                Text("검색")
                            })
                            .buttonStyle(.fullCar(
                                font: .pretendard16(.semibold),
                                horizontalPadding: 14,
                                verticalPadding: 15,
                                style: .palette(.primary_secondary)
                            ))
                        }
                    } else {
                        TextField("회사, 주소 검색", text: $company)
                            .textFieldStyle(.f
                                            ullCar(type: .search, state: $companyTextFieldState))
                    }
                },
                state: $companyTextFieldState,
                headerText: "안전한 카풀을 위해\n본인의 회사를 선택해 주세요.",
                headerFont: .pretendard22(.bold),
                headerPadding: 20
            )
        }
    }
}

#Preview {
    OnboardingView(viewModel: .init())
}
