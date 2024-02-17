//
//  MyCarPullListView.swift
//  FullCar
//
//  Created by Tabber on 2024/02/11.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit

struct MyCarPullListView: View {
    
    
    var body: some View {
        
        _body
        .navigationBarStyle(
            leadingView: {
                Button {
                    //viewModel.onBackButtonTapped()
                } label: {
                    Image(icon: .back)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.black)
                        .frame(width: 24, height: 24)
                }
            }, centerView: {
                Text("내카풀")
                    .font(.pretendard18(.bold))
            }, trailingView: {
            }
        )
    }
    
    private var _body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem()], content: {
                MyCarPullItemView()
                MyCarPullItemView()
                MyCarPullItemView()
            })
        }
    }
}

#Preview {
    MyCarPullListView()
}
