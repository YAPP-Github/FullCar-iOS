//
//  MyCarPullItemView.swift
//  FullCar
//
//  Created by Tabber on 2024/02/11.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

struct MyCarPullItemView: View {
    
    var item: CarPull.Model.Information
    
    var isLast: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 30) {
                Text(item.pickupLocation)
                    .lineLimit(1)
                    .font(.pretendard17(.bold))
                    .foregroundStyle(Color.black80)
                
                FCBadge(postState: .recruite)
            }
            
            HStack(spacing: 8) {
                Text("희망비용")
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.gray50)
                
                Text("\(item.money)원 • \(item.periodType.description)")
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.black80)
                
                Spacer()
                
                Text(item.createdAt.toDate())
                    .font(.pretendard14(.medium))
                    .foregroundStyle(Color.gray50)
            }
            .padding(.top, 18)
            
            if !isLast {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.gray30)
                    .padding(.top, 20)
            } else {
                EmptyView()
                    .padding(.top, 20)
            }
            
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        
    }
}
