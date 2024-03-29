//
//  RegisterView.swift
//  FullCar
//
//  Created by 한상진 on 1/20/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

import Dependencies
import XCTestDynamicOverlay

@MainActor
@Observable
final class CarPullRegisterViewModel {
    
    enum Destination: Hashable {
        case carRegister(Car.Register.ViewModel)
    }
    
    @ObservationIgnored
    @Dependency(\.carpullAPI) private var carpullAPI
    @ObservationIgnored
    @Dependency(\.fullCar) private var fullCar
    
    var changeTabToHome: () -> Void = unimplemented("changeTabToHome") 
    
    var paths: [Destination] = []
    
    var wishPlaceText: String = ""
    var wishPlaceState: InputState = .default
    
    var wishCostText: String = ""
    var wishCostState: InputState = .default
    
    var wishToSayText: String = ""
    
    var driversMood: Driver.Mood?
    var periodType: CarPull.Model.PeriodType?
    
    var error: Error?
    var apiIsInFlight: Bool = false
    var isRegisterFinished: Bool = false
    
    var isWishPlaceValid: Bool {
        !wishPlaceText.isEmpty && wishPlaceText.count <= 20
    } 
    var isWishCostValid: Bool {
        !wishCostText.isEmpty && wishCostText.count <= 10
    } 
    var isWishToSay: Bool {
        !wishToSayText.isEmpty && wishToSayText.count <= 150
    }
    var isValid: Bool {
        isWishPlaceValid && 
        periodType != nil && isWishCostValid &&
        isWishToSay
    }
    
    func wishPlaceTextChanged(_ wishPlaceText: String) {
        if wishPlaceText.count <= 20 { 
            self.wishPlaceState = .focus 
        } else {
            self.wishPlaceState = .error("희망 접선 장소는 20글자 까지 입력할 수 있어요.")
        }
        self.wishPlaceText = wishPlaceText
    } 
    
    func wishCostTextChanged(_ wishCostText: String) {
        if wishCostText.count <= 10 { 
            self.wishCostState = .focus 
        } else {
            self.wishCostState = .error("희망 비용은 10글자 까지 입력할 수 있어요.")
        }
        self.wishCostText = wishCostText
    }
    
    func wishToSayChanged(_ wishToSayText: String) {
        self.wishToSayText = wishToSayText
    }
    
    func moodButtonTapped(mood: Driver.Mood) {
        if self.driversMood == mood {
            self.driversMood = .none
        } else {
            self.driversMood = mood
        }
    }
    
    func periodSelectionButton(period: CarPull.Model.PeriodType) {
        self.periodType = period
    }
    
    func nextButtonTapped() async {
        guard let carId = fullCar.member?.carId else {
            guard paths.isEmpty else { return }
            let viewModel = Car.Register.ViewModel()
            let dismiss: () -> Void = { [weak self] in
                self?.paths.removeAll()
            }
            viewModel.onBackButtonTapped = dismiss
            viewModel.onRegisterFinished = dismiss
            self.paths.append(.carRegister(viewModel))
            return
        }
        
        do {
            guard 
                let moneyAmount = Int(wishCostText),
                let periodType 
            else { return }
            
            self.apiIsInFlight = true
            defer { self.apiIsInFlight = false }
            
            try await carpullAPI.register(
                pickupLocation: wishPlaceText,
                periodType: periodType,
                money: moneyAmount,
                content: wishToSayText,
                moodType: driversMood
            )
            
            self.isRegisterFinished = true
        }
        catch {
            self.error = error
        }
    }
    
    func onRegisterFinished() {
        wishPlaceText.removeAll()
        wishCostText.removeAll()
        wishToSayText.removeAll()
        driversMood = .none
        periodType = .none
        error = .none
        apiIsInFlight = false
        isRegisterFinished = false
        changeTabToHome()
    }
}

@MainActor
struct CarPullRegisterView: View {
    
    @Bindable var viewModel: CarPullRegisterViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.paths) { 
            _body
                .navigationBarStyle(
                    leadingView: { },
                    centerView: {
                        Text("카풀 등록")
                            .font(.pretendard18(.bold))
                    },
                    trailingView: { }
                )
                .navigationDestination(for: CarPullRegisterViewModel.Destination.self) { destination in
                    switch destination {
                    case let .carRegister(viewModel):
                        Car.Register.BodyView(viewModel: viewModel)
                    }
                }
                .alert(
                    "카풀 등록 오류",
                    isPresented: .init(
                        get: { viewModel.error != nil },
                        set: { _ in viewModel.error = nil }
                    ),
                    presenting: viewModel.error,
                    actions: { _ in
                        Button {
                            
                        } label: {
                            Text("확인")
                        }
                    },
                    message: { _ in
                        Text("카풀 등록 중 오류가 발생했어요.\n다시 시도해주세요.")
                    }
                )
                .alert(
                    "카풀 등록이 완료되었어요.",
                    isPresented: $viewModel.isRegisterFinished,
                    actions: { 
                        Button {
                            withAnimation { 
                                viewModel.onRegisterFinished()
                            }
                        } label: {
                            Text("확인")
                        }
                    }
                )
        }
    }
    
    private var _body: some View {
        ScrollView(.vertical) { 
            VStack(spacing: .zero) {
                wishPlaceTextField
                wishCostTextField
                wishToSayTextField
                driverMoodChips
                Spacer()
                nextButton
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var wishPlaceTextField: some View {
        FCTextFieldView(
            textField: {
                TextField(
                    "ex) 삼성역 5번 출구",
                    text: .init(
                        get: { viewModel.wishPlaceText }, 
                        set: { viewModel.wishPlaceTextChanged($0) }
                    )
                )
                .textFieldStyle(
                    .fullCar(
                        state: $viewModel.wishPlaceState,
                        padding: 16
                    )
                )
            },
            state: $viewModel.wishPlaceState,
            headerText: "희망 접선 장소",
            isHeaderRequired: true,
            headerPadding: 12,
            footerMessage: .error("희망 접선 장소는 20글자 까지 입력할 수 있어요.")
        )
        .padding(.top, 20)
        .padding(.bottom, 36)
    }
    
    private var wishCostTextField: some View {
        SectionView { 
            FCTextFieldView(
                textField: { periodSelectionView },
                state: $viewModel.wishCostState
            )
        } header: { 
            HeaderLabel(
                title: "희망 비용",
                isRequired: true,
                font: .pretendard16(.semibold)
            )
        }
        .padding(.bottom, 36)
    }
    
    private var periodSelectionView: some View {
        HStack(spacing: .zero) {
            periodSelectionButton
                .padding(.trailing, 12)
            
            TextField(
                "ex) 30,000",
                text: .init(
                    get: { viewModel.wishCostText },
                    set: { viewModel.wishCostTextChanged($0) }
                )
            )
            .keyboardType(.numberPad)
            .textFieldStyle(
                .fullCar(
                    type: .won,
                    state: $viewModel.wishCostState
                )
            )
        }
    }
    
    private var periodSelectionButton: some View {
        Menu {
            ForEach(CarPull.Model.PeriodType.allCases, id: \.self) { period in
                Button {
                    viewModel.periodSelectionButton(period: period)
                } label: {
                    Text(period.description)
                }
            }
        } label: {
            HStack(spacing: .zero) {
                Text(viewModel.periodType?.description ?? "기간")
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(viewModel.periodType == nil ? Color.gray45 : Color.black80)
                    .padding(.trailing, 8)
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.black80)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color.gray30)
            }
        }
    }
    
    private var wishToSayTextField: some View {
        VStack(spacing: .zero) {
            HeaderLabel(
                title: "탑승자에게 전할 말",
                isRequired: true,
                font: .pretendard16(.semibold)
            )
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            FCTextEditor(
                text: .init(
                    get: { viewModel.wishToSayText },
                    set: { viewModel.wishToSayChanged($0) }
                ),
                placeholder: "탑승자에게 하고 싶은 말이 있다면 자유롭게 작성해주세요!",
                font: .pretendard16(.semibold),
                padding: 16,
                radius: 10
            )
            .frame(height: 150)
        }
        .padding(.bottom, 36)
    }
    
    private var driverMoodChips: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("운행 분위기")
                .font(.pretendard16(.semibold))
                .foregroundStyle(Color.black80)
                .padding(.bottom, 12)
            
            HStack(spacing: .zero) {
                ForEach(Driver.Mood.allCases) { mood in
                    Button {
                        viewModel.moodButtonTapped(mood: mood)
                    } label: {
                        Text(mood.description)
                    }
                    .buttonStyle(.chip(viewModel.driversMood == mood))
                    .padding(.trailing, 6)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 24)
    }
    
    private var nextButton: some View {
        Button {
            Task { await viewModel.nextButtonTapped() }
        } label: {
            Text("등록하기")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(
            .fullCar(
                font: .pretendard17(.bold), 
                verticalPadding: 17, 
                radius: 8, 
                style: .palette(.primary_white)
            )
        )
        .disabled(!viewModel.isValid)
        .padding(.bottom, 24)
    }
}

#Preview {
    CarPullRegisterView(viewModel: .init())
}
