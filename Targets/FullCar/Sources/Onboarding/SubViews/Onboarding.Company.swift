//
//  Onboarding.Company.swift
//  FullCar
//
//  Created by Sunny on 2/7/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

extension Onboarding.Company {
    @MainActor
    struct BodyView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        @State private var isSearchViewAppear: Bool = false

        var body: some View {
            if !isSearchViewAppear {
                InputView(viewModel: viewModel, isSearchViewAppear: $isSearchViewAppear)
            } else {
                SearchView(viewModel: viewModel, isSearchViewAppear: $isSearchViewAppear)
            }
        }
    }

    @MainActor
    struct InputView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        @Binding var isSearchViewAppear: Bool

        var body: some View {
            companyTextFieldView
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
                    TextField("회사, 주소 검색", text: .constant(""))
                        .textFieldStyle(.fullCar(
                            type: .search,
                            state: $viewModel.companyTextFieldState)
                        )
                },
                state: $viewModel.companyTextFieldState,
                headerText: "안전한 카풀을 위해\n본인의 회사를 선택해 주세요.",
                headerFont: .pretendard22(.bold),
                headerPadding: 20
            )
            .onTapGesture {
                withAnimation {
                    isSearchViewAppear = true
                }
            }
        }
    }

    @MainActor
    struct SearchView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        @Binding var isSearchViewAppear: Bool

        var body: some View {
            bodyView
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        viewModel.companySearchBarState = .focus
                    }
                }
                .navigationBarStyle(
                    leadingView: {
                        NavigationButton(icon: .back, action: {
                            withAnimation {
                                isSearchViewAppear = false
                            }
                        })
                    },
                    centerView: {
                        Text("회사 검색")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: { }
                )
        }

        private var bodyView: some View {
            VStack(spacing: 1) {
                companySearchBar
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                locationList
            }
        }

        private var companySearchBar: some View {
            FCTextFieldView(
                textField: {
                    HStack {
                        TextField("회사, 주소 검색", text: $viewModel.company)
                            .textFieldStyle(
                                .fullCar(
                                    type: .none,
                                    state: $viewModel.companySearchBarState,
                                    padding: 16,
                                    backgroundColor: .gray5,
                                    cornerRadius: 10
                                ))

                        searchButton
                    }
                },
                state: $viewModel.companySearchBarState
            )
        }

        private var searchButton: some View {
            Button(action: {
                Task {
                    await viewModel.fetchCompanyCoordinate(viewModel.company)
                }
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

        private var locationList: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem()], spacing: .zero, content: {
                    ForEach($viewModel.locations, id: \.self) { item in
                        LocationListItem(location: item, company: viewModel.company)
                    }
                })
            }
        }
    }
}

#Preview {
    Onboarding.Company.BodyView(viewModel: .init())
}
