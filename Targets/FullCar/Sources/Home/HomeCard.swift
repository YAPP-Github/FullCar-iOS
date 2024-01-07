//
//  HomeCard.swift
//  FullCar
//
//  Created by 한상진 on 12/31/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

@MainActor
struct HomeCard: View {
    
    let carPull: Home.Model.TempCarPull
    
    var body: some View {
        bodyView
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(Color.white)
    }
    
    private var bodyView: some View {
        VStack(alignment: .leading, spacing: .zero) { 
            HStack(spacing: .zero) {
                Text(carPull.companyName)
                    .font(pretendard: .caption1)
                    .foregroundStyle(Color.fullCar_primary)
                Spacer()
                Badge(
                    title: "모집중",
                    configurable: .standard,
                    style: .palette(.primary_secondary)
                )
            }
            .padding(.bottom, 14)
            
            Text(carPull.title)
                .font(pretendard: .body1)
                .padding(.bottom, 12)
            
            Text(carPull.description)
                .font(pretendard: .body6)
                .padding(.bottom, 10)
            
            HStack(spacing: 6) {
                Badge(.female)
                Badge(.quiet)
            }
            
            Divider()
                .padding(.vertical, 18)
            
            HStack(spacing: .zero) {
                Text("희망비용")
                    .font(pretendard: .caption1)
                    .foregroundStyle(Color.gray50)
                    .padding(.trailing, 8)
                
                Text("48,000원")
                    .font(pretendard: .caption1)
                    .foregroundStyle(Color.black80)
                Spacer()
                Text("12월 28일")
                    .font(pretendard: .caption2)
                    .foregroundStyle(Color.gray40)
            }
        }
    }
}

#if DEBUG
#Preview {
    HomeCard(carPull: .mock)
}
#endif
