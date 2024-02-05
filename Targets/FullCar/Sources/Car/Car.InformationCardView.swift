//
//  CarInformationCardView.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

extension Car {
    @MainActor
    struct InformationCardView: View {
        let information: Car.Information
        
        var body: some View {
            bodyView
                .background(Color.white)
        }
        
        private var bodyView: some View {
            VStack(alignment: .leading, spacing: .zero) {
                Text("차량 정보")
                    .font(.pretendard17(.bold))
                    .padding(.bottom, 16)
                    .foregroundStyle(Color.black80)
                rowView(title: "차량 번호", content: information.carNumber.encryptedText)
                    .padding(.bottom, 12)
                rowView(title: "차량 종류", content: "\(information.carName) · \(information.carBrand)")
                    .padding(.bottom, 12)
                rowView(title: "차량 색상", content: information.carColor)
            }
            .padding(.all, 20)
        }
        private func rowView(title: String, content: String) -> some View {
            return HStack(spacing: .zero) {
                Text(title)
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.gray50)
                Spacer()
                Text(content)
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.black80)
            }
        }
    }

}

fileprivate extension String {
    var encryptedText: String {
        let carNumber: String = self
        let splited = carNumber.split(whereSeparator: \.isWhitespace)
        let prefix = splited[0].map { _ in return "*"}.joined()
        let suffix = splited[1]
        return "\(prefix) \(suffix)"
    }
}

#if DEBUG
#Preview {
    Car.InformationCardView(information: .mock)
        .background(Color.gray30)
}
#endif

