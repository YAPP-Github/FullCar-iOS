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
    
    let carpull: Home.Model.TempCarPull
    var body: some View {
        bodyView
//            .fullCarNavigationBar(title: "카풀 상세")
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
                HomeCardView(carPull: carpull)
                
                Color.gray10.frame(height: 8)
                
                CarInformationCardView(
                    information: .init(
                        number: "아반떼",
                        model: "23루 2341",
                        manufacturer: "현대자동차",
                        color: "화이트"
                    )
                )
                
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
            viewModel: .init(),
            carpull: .mock
        )
    }
}
#endif
