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
    @State private var isSelected: Bool = false

    var company: String
    var onTap: (() -> Void)?

    var body: some View {
        bodyView
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .border(width: 1, edges: [.bottom], color: .gray30)
            .background(isSelected ? Color.gray10 : Color.white)
            .onTapGesture {
                isSelected = true
                onTap?()
            }
    }

    private var bodyView: some View {
        HStack(alignment: .top, spacing: 10) {
            locationIcon

            locationInformation

            Spacer()
        }
    }

    private var locationIcon: some View {
        Image(icon: .location)
            .renderingMode(.template)
            .resizable()
            .frame(iconSize: ._24)
            .foregroundStyle(Color.gray40)
    }

    private var locationInformation: some View {
        VStack(alignment: .leading, spacing: 4) {
            highlightText(location.name, highlight: company)
                .font(.pretendard16_19(.medium))
                .foregroundStyle(Color.black80)

            Text(location.address ?? "")
                .font(.pretendard14(.semibold))
                .foregroundStyle(Color.gray45)
        }
    }

    private func highlightText(_ content: String, highlight: String) -> some View {
        let highlightContent = highlight.lowercased()
        guard let range = content.lowercased().range(of: highlightContent) else {
            return Text(content)
                .foregroundStyle(Color.black80)
        }

        let preString = String(content[..<range.lowerBound])
        let highlightString = String(content[range])
        let postString = String(content[range.upperBound...])

        let preText = Text(preString).foregroundStyle(Color.black80)
        let highlightText = Text(highlightString).foregroundStyle(Color.fullCar_primary)
        let postText = Text(postString).foregroundStyle(Color.black80)

        return preText + highlightText + postText
    }
}

#Preview {
    LocationListItem(
        location: .constant(.init(
            name: "123네이버124234",
            address: "경기 성남시 분당구 정자일로 95",
            latitude: 127.10520633434606,
            longitude: 37.3588600621634)
        ),
        company: "네이버"
    )
}
