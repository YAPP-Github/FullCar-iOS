//
//  CarPull.CardView.swift
//  FullCar
//
//  Created by 한상진 on 1/20/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

extension CarPull {
    
    @MainActor
    struct CardView: View {
        
        let carPull: CarPull.Model.Response
        
        var body: some View {
            bodyView
                .padding(.top, 18)
                .padding([.horizontal, .bottom], 20)
                .background(Color.white)
        }
        
        private var bodyView: some View {
            VStack(alignment: .leading, spacing: .zero) { 
                HStack(spacing: .zero) {
                    Text(carPull.companyName)
                        .font(.pretendard14(.semibold))
                        .foregroundStyle(Color.fullCar_primary)
                    Spacer()
                    
                    if let postState = carPull.postState {
                        FCBadge(postState: postState)
                    }
                    
                }
                .padding(.bottom, 14)
                
                Text(carPull.title)
                    .font(.pretendard17(.bold))
                    .padding(.bottom, 12)
                
                Text(carPull.description)
                    .font(.pretendard16(.regular))
                    .padding(.bottom, 10)
                
                if let driver = carPull.driver {
                    HStack(spacing: 6) {
                        FCBadge(gender: driver.gender)
                        FCBadge(mood: driver.mood)
                    }
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
    
}

#if DEBUG
#Preview {
    VStack {
        CarPull.CardView(carPull: .mock)
            .debug()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray)
}
#endif
