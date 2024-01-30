//
//  CompanyListItem.swift
//  FullCar
//
//  Created by Sunny on 1/30/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

struct CompanyListItem: View {
    var body: some View {
        bodyView
    }

    private var bodyView: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(icon: .location)
                .renderingMode(.template)
                .resizable()
                .frame(iconSize: ._24)
                .foregroundStyle(Color.gray40)

            VStack(alignment: .leading, spacing: 4) {
                Text("NAVER")
                    .font(.pretendard16(.medium))
                    .foregroundStyle(Color.black80)

                Text("경기 성남시 분당구 정자일로 95")
                    .font(.pretendard14(.semibold))
                    .foregroundStyle(Color.gray45)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .border(width: 1, edges: [.bottom], color: .gray30)
    }
}

#Preview {
    CompanyListItem()
}
