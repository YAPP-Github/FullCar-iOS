//
//  CarPullDetailView.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

@MainActor
struct CarPullDetailView: View {
    let viewModel: CarPullDetailViewModel
    
    var body: some View {
        bodyView
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
                    Text("카풀 상세")
                        .font(.pretendard18(.bold))
                }, trailingView: { 
                    Button {
                        
                    } label: {
                        Image(icon: .menu)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                            .frame(width: 24, height: 24)
                    }
                }
            )
            .background(Color.white)
    }
    
    private var bodyView: some View {
        VStack(spacing: .zero) {
            contentView
            Spacer()
            beginRequestButton
                .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var contentView: some View {
        ScrollView(.vertical) {
            VStack(spacing: .zero) {
                CarPull.CardView(carPull: viewModel.carPull)
                
                Color.gray10.frame(height: 8)
                
                Car.InformationCardView(information: viewModel.information)
                
                if viewModel.requestStatus == .inProcess {
                    Text("희망 접선 장소 해야함")
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var beginRequestButton: some View {
        Button { viewModel.beginRequestButtonTapped() } 
        label: { Text("탑승요청") }
        .buttonStyle(
            .fullCar(
                font: .pretendard17(.bold),
                horizontalPadding: 137,
                verticalPadding: 17,
                radius: 8,
                style: .palette(.primary_white)
            )
        )
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        CarPullDetailView(
            viewModel: .init(
                requestStatus: .beforeBegin,
                carPull: .mock,
                information: .mock
            )
        )
    }
}
#endif
