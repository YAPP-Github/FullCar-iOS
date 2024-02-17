//
//  CarPullAcceptTypingView.swift
//  FullCar
//
//  Created by Tabber on 2024/02/10.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit

struct CarPullAcceptTypingView: View {
    
    @Bindable var viewModel: CallListDetailViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            FCTextFieldView(
                textField: {
                    TextField("핸드폰 번호, 카카오톡 아이디등", text: $viewModel.myCallNumber)
                        .textFieldStyle(
                            .fullCar(state: $viewModel.myCallNumberState, padding: 16)
                        )
                },
                state: $viewModel.myCallNumberState,
                headerText: "연락처",
                isHeaderRequired: true
            )
            .padding(.bottom, 28)
            
            Group {
                HeaderLabel(
                    title: "탑승자에게 전할 말",
                    isRequired: true,
                    font: .pretendard16(.semibold)
                )
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                FCTextEditor(
                    text: $viewModel.sendText,
                    placeholder: "탑승자에게 하고 싶은 말이 있다면 자유롭게 작성해주세요!",
                    font: .pretendard16(.semibold),
                    padding: 16,
                    radius: 10
                )
                .frame(height: 150)
            }
            
        }
        .padding(.all, 20)
    }
}
