//
//  Car.Register.View.swift
//  FullCar
//
//  Created by 한상진 on 2/3/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

import Dependencies

extension Car.Register {
    @MainActor
    @Observable
    final class ViewModel {
        var carNumber: String = ""
        var carNumberState: InputState = .default
        
        var carName: String = ""
        var carNameState: InputState = .default
        
        var carBrand: String = ""
        var carBrandState: InputState = .default
        
        var carColor: String = ""
        var carColorState: InputState = .default
        
        @ObservationIgnored
        @Dependency(\.carRegisterAPI) private var carRegisterAPI
        
        func registerButtonTapped() async {
            do {
                try await carRegisterAPI.fetch(
                    carNumber: carNumber,
                    carName: carName,
                    carBrand: carBrand,
                    carColor: carColor
                )
            }
            catch {
                print(error)
            }
        }
    }
}

extension Car.Register {
    @MainActor
    struct BodyView: View {
        @Bindable var viewModel: ViewModel
        
        var body: some View {
            ScrollView(.vertical) { 
                bodyView
                    .padding(.horizontal, 20)
            }
        }
        
        private var bodyView: some View {
            VStack(spacing: .zero) {
                Text("차량 등록이 필요해요!\n오늘 이후 차량 등록을 하지 않아요.")
                    .font(.pretendard22(.bold))
                    .foregroundStyle(Color.black80)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 30)
                
                FCTextFieldView(
                    textField: {
                        TextField("ex) 23루 1234", text: $viewModel.carNumber)
                            .textFieldStyle(
                                .fullCar(type: .won, state: $viewModel.carNumberState)
                            )
                    },
                    state: $viewModel.carNumberState,
                    headerText: "차량번호",
                    isHeaderRequired: true,
                    footerMessage: .information("차량 번호는 카풀이 매칭된 이후에만 공개됩니다", icon: .check)
                )
                .padding(.bottom, 36)
                
                FCTextFieldView(
                    textField: {
                        TextField("ex) 아반떼, 레이, 코나 등", text: $viewModel.carName)
                            .textFieldStyle(
                                .fullCar(type: .won, state: $viewModel.carNameState)
                            )
                    },
                    state: $viewModel.carNameState,
                    headerText: "차량명",
                    isHeaderRequired: true
                )
                .padding(.bottom, 36)
                
                FCTextFieldView(
                    textField: {
                        TextField("ex) 현대, 기아, 벤츠 등", text: $viewModel.carBrand)
                            .textFieldStyle(
                                .fullCar(type: .won, state: $viewModel.carBrandState)
                            )
                    },
                    state: $viewModel.carBrandState,
                    headerText: "브랜드",
                    isHeaderRequired: true
                )
                .padding(.bottom, 36)
                
                FCTextFieldView(
                    textField: {
                        TextField("ex) 화이트", text: $viewModel.carColor)
                            .textFieldStyle(
                                .fullCar(type: .won, state: $viewModel.carColorState)
                            )
                    },
                    state: $viewModel.carColorState,
                    headerText: "색상",
                    isHeaderRequired: true
                )
                .padding(.bottom, 36)
                
                Button {
                    Task {
                        await viewModel.registerButtonTapped()
                    }
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
                .padding(.bottom, 19)
            }
        }
    }
}

#if DEBUG
    #Preview {
        Car.Register.BodyView(viewModel: .init())
    }
#endif
