//
//  LocationListItem.swift
//  FullCar
//
//  Created by Sunny on 1/30/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarKit

struct LocationListItem: View {

    @Binding var location: LocalCoordinate

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
                Text(location.name)
                    .font(.pretendard16_19(.medium))
                    .foregroundStyle(Color.black80)

                Text(location.address)
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
    LocationListItem(location: .constant(.init(
        name: "네이버",
        address: "경기 성남시 분당구 정자일로 95",
        latitude: 127.10520633434606,
        longitude: 37.3588600621634)
    ))
}
