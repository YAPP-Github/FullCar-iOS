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
        
        let carPull: CarPull.Model.Information
        
        var body: some View {
            bodyView
                .padding(.top, 18)
                .padding([.horizontal, .bottom], 20)
                .background(Color.white)
        }
        
        private var bodyView: some View {
            VStack(alignment: .leading, spacing: .zero) { 
                HStack(spacing: .zero) {
                    Text(carPull.companyName ?? "")
                        .font(.pretendard14(.semibold))
                        .lineLimit(1)
                        .foregroundStyle(Color.fullCar_primary)
                    Spacer()
                    
                    if let carpoolState = carPull.carpoolState {
                        FCBadge(
                            title: carpoolState.description,
                            badgeConfigurable: .init(
                                font: .pretendard12(.bold),
                                style: carPull.carpoolState == .OPEN ? .palette(.primary_secondary) : .palette(.gray60)
                            ),
                            iconConfigurable: .init(location: .none)
                        )
                    } else if let formState = carPull.formState {
                        FCBadge(title: formState.description,
                                badgeConfigurable: .init(font: .pretendard12(.bold), style: .palette(getColor())),
                                iconConfigurable: .init(location: .none))
                    }
                    
                    
                }
                .padding(.bottom, 14)
                
                Text(carPull.pickupLocation)
                    .font(.pretendard17(.bold))
                    .lineLimit(1)
                    .padding(.bottom, 12)
                
                Text(carPull.content ?? "")
                    .font(.pretendard16(.regular))
                    .lineLimit(2)
                    .padding(.bottom, 10)
                
                HStack(spacing: 6) {
                    if let gender = carPull.gender {
                        FCBadge(gender: gender)
                    }
                    if let moodType = carPull.moodType {
                        FCBadge(mood: moodType)
                    }
                }
                
                Divider()
                    .padding(.vertical, 18)
                
                HStack(spacing: .zero) {
                    Text("희망비용")
                        .font(.pretendard14(.semibold))
                        .foregroundStyle(Color.gray50)
                        .padding(.trailing, 8)
                    Text("\(carPull.money)원·\(carPull.periodType.description)")
                        .font(.pretendard14(.semibold))
                        .foregroundStyle(Color.black80)
                    Spacer()
                    Text(carPull.createdAt.toDate())
                        .font(.pretendard14(.semibold))
                        .foregroundStyle(Color.gray40)
                }
            }
        }
        
        func getColor() -> ColorStyle.Palette {
            switch carPull.formState ?? .REQUEST {
            case .REQUEST:
                return .primary_secondary
            case .ACCEPT:
                return .green
            case .REJECT:
                return .red
            }
        }
    }
    
    
}

#if DEBUG
#Preview {
    VStack {
        CarPull.CardView(carPull: .mock())
            .debug()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray)
}
#endif
