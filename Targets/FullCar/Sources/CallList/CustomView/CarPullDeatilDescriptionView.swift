//
//  CarPullDeatilDescriptionView.swift
//  FullCar
//
//  Created by Tabber on 2024/02/10.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

struct CarPullDeatilDescriptionView: View {
    
    var item: CarPull.Model.Information
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.fullCar_primary_background50)
            
            VStack(alignment: .leading, spacing: 12) {
                if let message = item.resultMessage?.contact {
                    HStack(spacing: 0) {
                        Image(icon: .messageText)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16, alignment: .center)
                        Text(message)
                            .font(.pretendard14(.semibold))
                            .foregroundStyle(Color.fullCar_primary)
                            .padding(.leading, 6)
                    }
                }
                
                if let toPassenger = item.resultMessage?.toPassenger {
                    Text(toPassenger)
                        .font(.pretendard16(.regular))
                }
                
                
            }
            .padding(.all, 16)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 20)
        
    }
}

#Preview {
    CarPullDeatilDescriptionView(item: .init(id: 5,
                                             pickupLocation: "봉천역",
                                             periodType: .oneWeek,
                                             money: 10000,
                                             content: "봉천역에서 카풀해요~",
                                             moodType: .quiet,
                                             formState: .ACCEPT,
                                             carpoolState: .OPEN,
                                             nickname: "알뜰한 물개",
                                             companyName: "현대자동차",
                                             gender: .male, resultMessage: .init(contact: "탑승자에게 보내는 메시지", toPassenger: "연락은 카톡으로 드리겠습니다~\n내일 뵙겠습니다."),
                                             createdAt: Date()))
}
