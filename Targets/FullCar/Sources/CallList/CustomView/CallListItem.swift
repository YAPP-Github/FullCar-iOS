//
//  CallListItem.swift
//  FullCar
//
//  Created by Tabber on 2024/01/06.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Observation

struct CallListItem: View {
    
    private(set) var status: FullCar.CallStatus = .failure
    var isLast: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                
                requestStatusView
                
                Group {
                    mainTitleView
                    subDescriptionView
                }
                .padding(.top, 18)
            }
            .padding(.all, 20)
            
            if !isLast {
                Divider()
                    .padding(.horizontal, 20)
            }
        }
        
    }
}

extension CallListItem {
    var requestStatusView: some View {
        ZStack {
            HStack(spacing: 0) {
                Text("삼성전자")
                    .font(.system(size: 14))
                    .foregroundStyle(.blue)
                    .bold()
                
                Text("알뜰한 물개")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray.opacity(0.5))
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                statusBadgeView
                
            }
        }
    }
    
    var statusBadgeView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .foregroundStyle(getColor(back: true))
            Text(status.rawValue)
                .foregroundStyle(getColor())
                .font(.system(size: 12))
                .bold()
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
        }
        .fixedSize()
    }
    
    var mainTitleView: some View {
        HStack {
            
            Text("봉천역 2번출구")
                .bold()
                .font(.system(size: 17))
            
            Spacer()
        }
    }
    
    var subDescriptionView: some View {
        ZStack {
            HStack {
                
                Text("희망비용")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray.opacity(0.5))
                    .bold()
                
                Text("48,000원 • 1주간")
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
                    .bold()
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Text("12월 28일")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray.opacity(0.5))
                    .bold()
            }
        }
    }
}

//MARK: Action
extension CallListItem {
    func getColor(back: Bool = false) -> Color {
        switch status {
        case .waiting:
            return back ? .blue.opacity(0.2) : .blue
        case .success:
            return back ? .green.opacity(0.2) : .green
        case .failure:
            return back ? .red.opacity(0.2) : .red
        }
    }
}

#Preview {
    CallListItem()
}
