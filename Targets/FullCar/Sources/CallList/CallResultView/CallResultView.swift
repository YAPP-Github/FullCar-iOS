//
//  CallResultView.swift
//  FullCar
//
//  Created by Tabber on 2024/02/10.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

extension CallResultView {
    enum CallResultType {
    case success
    case denied
    }
}

struct CallResultView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var type: CallResultType = .success
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: .zero) {
                
                switch type {
                case .success:
                    Image(icon: .resultSuccess)
                        .padding(.top, 60)
                case .denied:
                    Image(icon: .resultDenied)
                        .padding(.top, 60)
                }
                
                
                Text("탑승 요청을")
                    .font(.pretendard28(.bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                
                switch type {
                case .success:
                    Text("승인했습니다.")
                        .font(.pretendard28(.bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                case .denied:
                    Text("거절했습니다.")
                        .font(.pretendard28(.bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                
                
                CarPull.CardView(carPull: .init(id: 0,
                                                pickupLocation: "봉천역",
                                                periodType: .oneWeek,
                                                money: 1000, content: "타이틀",
                                                moodType: nil,
                                                formState: .ACCEPT,
                                                carpoolState: .OPEN,
                                                nickname: "알뜰한 물개",
                                                companyName: "회사이름", gender: nil, resultMessage: nil, createdAt: Date()))
                .padding(.top, 36)
            }
            
           
        }
        
        Spacer()
        
        Button(action: {
            dismiss()
        }, label: {
            HStack {
                Spacer()
                Text("홈으로 이동")
                Spacer()
            }
        })
        .buttonStyle(
            .fullCar(
                font: .pretendard17(.bold),
                verticalPadding: 17,
                radius: 8,
                style: .palette(.primary_white)
            )
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    CallResultView()
}
