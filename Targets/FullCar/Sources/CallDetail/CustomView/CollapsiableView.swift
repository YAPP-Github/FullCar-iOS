//
//  CollapsiableView.swift
//  FullCar
//
//  Created by Tabber on 2024/01/08.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

struct CollapsiableView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
                .padding(.bottom, 18)
            
            companyUserStatusView
            mainTitleView
                .padding(.top, 14)
            
            mainDescriptionView
                .padding(.top, 12)
            
            optionBadgeView
                .padding(.top, 10)
            
            Divider()
                .padding(.top, 20)
            
            wishPayView
                .padding(.top, 18)
            
        }
        .padding(.horizontal, 20)
    }
    
}

extension CollapsiableView {
    
    var companyUserStatusView: some View {
        HStack(spacing: 0) {
            
            Text("현대자동차")
                .bold()
                .foregroundStyle(.blue.opacity(0.7))
                .font(.system(size: 14))
            
            Text("알뜰한 물개")
                .font(.system(size: 14))
                .foregroundStyle(.gray.opacity(0.5))
                .bold()
                .padding(.leading, 8)
            Spacer()
            statusBadgeView
        }
    }
    
    var statusBadgeView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .foregroundStyle(.blue.opacity(0.3))
            Text("모집중")
                .foregroundStyle(.blue)
                .font(.system(size: 12))
                .bold()
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
        }
        .fixedSize()
    }
    
    var mainTitleView: some View {
        Text("봉천역 2번출구에서 출발할게요~")
            .bold()
            .font(.system(size: 17))
    }
    
    var mainDescriptionView: some View {
        Text("월수금만 카풀하실 분 구합니다. 봉천역 2번출구에서 픽업할 예정이고 시간약속 잘지키시면 좋을 것 같습니다! 비용은 제시해주셔도 됩니다.")
            .multilineTextAlignment(.leading)
            
    }
    
    var optionBadgeView: some View {
        HStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .foregroundStyle(.gray.opacity(0.1))
                HStack(spacing: 0) {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundStyle(.gray.opacity(0.6))
                    
                    Text("여성 운전자")
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                        .bold()
                        .padding(.leading, 2)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                
            }
            .fixedSize()
            
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .foregroundStyle(.gray.opacity(0.1))
                HStack(spacing: 0) {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundStyle(.gray.opacity(0.6))
                    
                    Text("여성 운전자")
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                        .bold()
                        .padding(.leading, 2)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                
            }
            .fixedSize()
            
            Spacer()
        }
    }
    
    var wishPayView: some View {
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

#Preview {
    CollapsiableView()
}
