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
    
    private(set) var isOpen: CarPull.Model.CarPoolStateType = .OPEN
    private(set) var status: CarPull.Model.FormStateType = .REJECT
    private(set) var item: CarPull.Model.Information
    
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
                Text("\(item.companyName)")
                    .font(.system(size: 14))
                    .foregroundStyle(.blue)
                    .bold()
                
                Text("\(item.nickname ?? "")")
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
            Text(status.description)
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
            
            Text(item.pickupLocation)
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
                
                Text("\(item.money)원 • \(item.periodType.description)")
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
                    .bold()
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Text("\(item.createdAt.toLocalTime())")
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
        case .REQUEST:
            return back ? .fullCar_secondary : .fullCar_primary
        case .ACCEPT:
            return back ? .green50 : .green100
        case .REJECT:
            return back ? .red50 : .red100
        }
    }
}
