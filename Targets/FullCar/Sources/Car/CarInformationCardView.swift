//
//  CarInformationCardView.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

@MainActor
struct CarInformationCardView: View {
    let information: Car.Information
    
    var body: some View {
        bodyView
            .background(Color.white)
    }
    
    private var bodyView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("차량 정보")
                .padding(.bottom, 16)
                .foregroundStyle(Color.black80)
            rowView(title: "차량 번호", content: information.number)
                .padding(.bottom, 12)
            rowView(title: "차량 종류", content: "\(information.model) · \(information.manufacturer)")
                .padding(.bottom, 12)
            rowView(title: "차량 색상", content: information.color)
        }
        .padding(.all, 20)
    }
    private func rowView(title: String, content: String) -> some View {
        return HStack(spacing: .zero) {
            Text(title)
                .foregroundStyle(Color.gray50)
            Spacer()
            Text(content)
                .foregroundStyle(Color.black80)
        }
    }
}

#if DEBUG
#Preview {
    CarInformationCardView(information: .mock)
        .background(Color.gray30)
}
#endif

