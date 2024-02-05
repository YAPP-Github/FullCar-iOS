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

@MainActor
@Observable
final class CarPullRegisterViewModel {
    
    @ObservationIgnored
    @Dependency(\.carpullAPI) private var carpullAPI 
    
    var wishPlaceText: String = ""
    var wishPlaceState: InputState = .default
    
    var wishCostText: String = ""
    var wishCostState: InputState = .default
    
    var wishToSayText: String = ""
    
    var driversMood: Driver.Mood?
    var periodType: CarPull.Model.PeriodType?
    
    var isValid: Bool {
        !wishPlaceText.isEmpty && wishPlaceText.count <= 20 && 
        periodType != nil && 
        !wishCostText.isEmpty && wishCostText.count <= 10 &&
        !wishToSayText.isEmpty && wishToSayText.count <= 150
    }
    
    func moodButtonTapped(mood: Driver.Mood) {
        self.driversMood = mood
    }
    
    func periodSelectionButton(period: CarPull.Model.PeriodType) {
        self.periodType = period
    }
    
    func nextButtonTapped() async {
        do {
            let res = try await carpullAPI.register(
                pickupLocation: wishPlaceText,
                periodType: periodType!,
                money: Int(wishCostText)!,
                content: wishToSayText,
                moodType: driversMood
            )
        }
        catch {
            print(error)
        }
    }
}

@MainActor
struct CarPullRegisterView: View {
    
    @Bindable var viewModel: CarPullRegisterViewModel
    
    var body: some View {
        _body
        // FIXME: 탭으로 변경
            .navigationBarStyle(
                leadingView: {
                    Button {
                        
                    } label: {
                        Image(icon: .back)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                            .frame(width: 24, height: 24)
                    }
                }, centerView: {
                    Text("카풀 등록")
                        .font(.pretendard18(.bold))
                }, trailingView: {
                    EmptyView() 
                }
            )
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
                TextField("ex) 삼성역 5번 출구", text: $viewModel.wishPlaceText)
                    .textFieldStyle(
                        .fullCar(state: $viewModel.wishPlaceState, padding: 16)
                    )
            },
            state: $viewModel.wishPlaceState,
            headerText: "희망 접선 장소",
            isHeaderRequired: true,
            headerPadding: 12
        )
        .padding(.top, 20)
        .padding(.bottom, 36)
    }
    
    // TODO: 드롭 다운 추가하기
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
            
            TextField("ex) 30,000", text: $viewModel.wishCostText)
                .textFieldStyle(
                    .fullCar(type: .won, state: $viewModel.wishCostState)
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
                text: $viewModel.wishToSayText,
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
        .padding(.bottom, 40)
    }
    
    private var nextButton: some View {
        Button {
            Task { await viewModel.nextButtonTapped() }
        } label: {
            Text("다음")
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
    }
}

#Preview {
    CarPullRegisterView(viewModel: .init())
}
