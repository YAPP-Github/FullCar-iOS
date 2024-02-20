//
//  CallListTabView.swift
//  FullCar
//
//  Created by Tabber on 2024/01/06.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Observation

struct CallListTabView: View {
    @Binding var selection: FullCar.CallListTab
    
    @Binding var requests: [CarPull.Model.Information]
    @Binding var receives: [CarPull.Model.Information]
    
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                tabItemView(type: .request)
                tabItemView(type: .receive)
            }
        }
    }
    
    func tabItemView(type: FullCar.CallListTab) -> some View {
        
        VStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    selection = type
                }
            }, label: {
                VStack {
                    switch type {
                    case .request:
                        Text("요청한 내역 \(requests.count)")
                            .bold()
                            .foregroundStyle(selection == type ? .black : .gray.opacity(0.45))
                        
                    case .receive:
                        Text("요청받은 내역 \(receives.count)")
                            .bold()
                            .foregroundStyle(selection == type ? .black : .gray.opacity(0.45))
                    }
                }
            })
            .foregroundStyle(.black)
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.2))
                    .frame(height: 2)
                    .padding(.top, 15)
                
                if type == selection {
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(height: 2)
                        .padding(.top, 15)
                        .padding(.horizontal, 21)
                        .matchedGeometryEffect(id: "title", in: animation)
                }
            }
        }
        
        
    }
}
