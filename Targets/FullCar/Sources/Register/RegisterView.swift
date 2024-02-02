//
//  RegisterView.swift
//  FullCar
//
//  Created by 한상진 on 1/20/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

@MainActor
@Observable
final class RegisterViewModel {
    enum Focused {
        case wishPlace
        case wishCost
        case wishToSay
    }
    
    var wishState: InputState = .default
    var wishPlaceText: String = ""
    var driversMood: Set<Driver.Mood> = .init()
    
    func moodButtonTapped(mood: Driver.Mood) {
        if driversMood.contains(mood) {
            driversMood.remove(mood)
        } else {
            driversMood.insert(mood)
        }
    }
    
    func nextButtonTapped() async {
        
    }
}

@MainActor
struct RegisterView: View {
    
    @Bindable var viewModel: RegisterViewModel
    
    var body: some View {
        _body
            .navigationBarStyle(
                leadingView: {
                    Image(icon: .back)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.black)
                        .frame(width: 24, height: 24)
                }, centerView: {
                    Text("카풀 등록")
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
                        .fullCar(type: .won, state: $viewModel.wishState)
                    )
            },
            state: $viewModel.wishState,
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
                textField: {
                    TextField("ex) 30,000", text: .constant(""))
                        .textFieldStyle(
                            .fullCar(type: .won, state: .constant(.default))
                        )
                },
                state: .constant(.default)
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
                text: .constant(""),
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
                        Text(mood.rawValue)
                    }
                    .buttonStyle(.chip(viewModel.driversMood.contains(mood)))
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
    }
}

#Preview {
    RegisterView(viewModel: .init())
}
