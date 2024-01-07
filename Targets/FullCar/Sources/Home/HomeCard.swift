//
//  HomeCard.swift
//  FullCar
//
//  Created by 한상진 on 12/31/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import SwiftUI

struct HomeCard: View {
    
    let carPull: Home.Model.TempCarPull
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) { 
            HStack(spacing: .zero) {
                Text(carPull.companyName)
                Spacer()
                Text(carPull.state.description)
            }
            Text(carPull.title)
            Text(carPull.description)
            // chips
            Divider()
            HStack(spacing: .zero) {
                Text("희망비용")
                Text("48,000원")
                Spacer()
                Text("12월 28일")
            }
        }
    }
}

#if DEBUG
#Preview {
    HomeCard(carPull: .mock)
}
#endif
