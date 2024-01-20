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
struct HomeCardView: View {
    
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
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.fullCar_primary)
                Spacer()
                FCBadge(postState: .recruite)
            }
            .padding(.bottom, 14)
            
            Text(carPull.title)
                .font(.pretendard17(.bold))
                .padding(.bottom, 12)
            
            Text(carPull.description)
                .font(.pretendard16(.regular))
                .padding(.bottom, 10)
            
            HStack(spacing: 6) {
                FCBadge(gender: .female)
                FCBadge(mood: .quiet)
            }
            
            Divider()
                .padding(.vertical, 18)
            
            HStack(spacing: .zero) {
                Text("희망비용")
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.gray50)
                    .padding(.trailing, 8)
                
                Text("48,000원")
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.black80)
                Spacer()
                Text("12월 28일")
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.gray40)
            }
        }
    }
}

#if DEBUG
#Preview {
    HomeCardView(carPull: .mock)
}
#endif
