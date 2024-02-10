//
//  MyCarpoolItem.swift
//  FullCar
//
//  Created by Sunny on 2/11/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

struct MyCarpoolItem: View {
    var body: some View {
        bodyView
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 20)
    }

    private var bodyView: some View {
        VStack(spacing: 18) {
            titleView

            subView
        }
    }

    private var titleView: some View {
        HStack(spacing: 30) {
            Text("봉천역 2번출구에서 출발할께요 어쩌...")
                .font(.pretendard17(.bold))
                .lineLimit(1)

            Spacer()

            FCBadge(postState: .recruite)
        }
    }

    private var subView: some View {
        HStack(spacing: 8) {
            Text("희망비용")
                .font(.pretendard14(.semibold))
                .foregroundStyle(Color.gray50)

            Text("48,000원 · 1주간")
                .font(.pretendard14(.semibold))
                .foregroundStyle(Color.black80)

            Spacer()

            Text("12월 28일")
                .font(.pretendard14(.medium))
                .foregroundStyle(Color.gray40)
        }
    }
}

#if DEBUG
#Preview {
    MyCarpoolItem()
}
#endif

