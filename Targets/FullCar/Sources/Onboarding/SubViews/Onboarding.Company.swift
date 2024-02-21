//
//  Onboarding.Company.swift
//  FullCar
//
//  Created by Sunny on 2/7/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit

extension Onboarding.Company {
    @MainActor
    struct BodyView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            InputView(viewModel: viewModel)
                .sheet(isPresented: $viewModel.isSearchViewAppear) {
                    SearchView(viewModel: viewModel)
                }
        }
    }

    @MainActor
    struct InputView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            NavigationStack {
                companyTextFieldView
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .padding(.bottom, 16)
                    .navigationBarStyle(
                        leadingView: { 
                            NavigationButton(icon: .back) { viewModel.onBackButtonTapped() }
                        },
                        centerView: {
                            Text("회원 가입")
                                .font(.pretendard18(.bold))
                        },
                        trailingView: { }
                    )
                    .navigationDestination(isPresented: $viewModel.isOnboardingViewAppear) {
                        Onboarding.BodyView(viewModel: viewModel)
                    }
            }
        }

        private var companyTextFieldView: some View {
            VStack(spacing: .zero) {
                companyTextField

                Spacer()

                nextButton
            }
        }

        private var companyTextField: some View {
            FCTextFieldView(
                textField: {
                    TextField("회사, 주소 검색", text: .constant(viewModel.company?.name ?? ""))
                        .textFieldStyle(.fullCar(
                            type: viewModel.company == nil ? .search : .check($viewModel.isCompanyValid),
                            state: .constant(.default))
                        )
                        .disabled(true)
                },
                state: .constant(.default),
                headerText: "안전한 카풀을 위해\n본인의 회사를 선택해 주세요.",
                headerFont: .pretendard22(.bold),
                headerPadding: 20
            )
            .onTapGesture {
                viewModel.isSearchViewAppear = true
            }
        }

        private var nextButton: some View {
            Button(action: {
                viewModel.isOnboardingViewAppear = true
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
            .disabled(!viewModel.isCompanyValid)
        }
    }

    @MainActor
    struct SearchView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        @State var keyword: String = ""
        @State var locations: [LocalCoordinate] = []
        @State var onSearchButtonTapped: Bool = false
        @State var isLoading: Bool = false

        @FocusState private var isFocused: Onboarding.Field?

        var body: some View {
            bodyView
                .navigationBarStyle(
                    leadingView: { },
                    centerView: {
                        Text("회사 검색")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: { }
                )
                .onAppear {
                    isFocused = .company
                }
        }

        private var bodyView: some View {
            ZStack {
                VStack(spacing: 1) {
                    companySearchBar
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    locationList
                }

                if isLoading && isFocused == nil {
                    DimView(color: Color.fullCar_primary, scale: 1.3)
                }
            }
        }

        private var companySearchBar: some View {
            FCTextFieldView(
                textField: {
                    HStack {
                        TextField("회사, 주소 검색", text: $keyword)
                            .focused($isFocused, equals: .company)
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
                    isFocused = nil
                    isLoading = true

                    let coordinates = await viewModel.fetchCompanyCoordinate(keyword)
                    locations = coordinates

                    onSearchButtonTapped = true
                    isLoading = false
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
                if locations.isEmpty && onSearchButtonTapped {
                    emptyLocationList
                        .padding(.top, 104)
                } else {
                    LazyVGrid(columns: [GridItem()], spacing: .zero, content: {
                        ForEach(locations.indices, id: \.self) { index in
                            LocationListItem(
                                location: $locations[index],
                                isFirst: index == 0,
                                company: keyword,
                                onTap: { viewModel.onTappedLocation(locations[index]) }
                            )
                        }
                    })
                }
            }
        }

        private var emptyLocationList: some View {
            VStack(spacing: 20) {
                Image(icon: .car_gray)
                    .resizable()
                    .frame(width: 49, height: 67.7)

                VStack(spacing: 6) {
                    Text("검색 결과가 없습니다.")
                        .font(.pretendard18(.bold))
                        .foregroundStyle(Color.gray45)

                    Text("회사명의 철자가 정확한지 확인해 주세요.")
                        .font(.pretendard16(.regular))
                        .foregroundStyle(Color.gray40)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    Onboarding.Company.BodyView(viewModel: .init())
}
#endif
