//
//  CallListDeatilView.swift
//  FullCar
//
//  Created by Tabber on 2024/02/03.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit

@MainActor
struct CallListDetailView: View {
    
    var viewModel: CallListDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                toggleView
                requestView
            }
            
            HStack {
                requestDisableButton
                requestAcceptButton
            }
        }
        .navigationBarStyle(
            leadingView: {
                NavigationButton(icon: .back, action: {
                    viewModel.onBackButtonTapped()
                })
            },
            centerView: {
                Text("요청 상세")
                    .font(.pretendard18(.bold))
            },
            trailingView: { }
        )
        
    }
    
    private var toggleView: some View {
        VStack(spacing: 0) {
            
            Button(action: {
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.toggleOpen.toggle()
                }
                
                withAnimation(.smooth) {
                    
                    viewModel.toggleRotate += 180
                }
            }, label: {
                HStack(spacing: 0) {
                    
                    Text("카풀 상세")
                        .font(.pretendard17(.bold))
                        .foregroundStyle(Color.black80)
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(viewModel.toggleRotate))
                        .foregroundStyle(Color.black80)
                }
                .padding(.all, 20)
            })
            
            if viewModel.toggleOpen {
                
                CarPull.CardView(carPull: .init(id: 0, pickupLocation: "봉천역", periodType: .oneWeek, money: 1000, content: "타이틀", moodType: .quiet, companyName: "회사이름", gender: .female, createdAt: Date()))
                
                Rectangle()
                    .foregroundStyle(Color.gray10)
                    .frame(height: 8, alignment: .center)
                
                Car.InformationCardView(information: .init(id: 1, carNumber: "23루 4343", carName: "SUV", carBrand: "볼보", carColor: "화이트"))
            }
            
            Rectangle()
                .foregroundStyle(Color.gray10)
                .frame(height: 8, alignment: .center)
        }
    }
    
    private var requestView: some View {
        
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                Text("요청받은 내역")
                    .font(.pretendard17(.bold))
                    .foregroundStyle(Color.black80)
                Spacer()
            }
            .padding(.all, 20)
            
            Divider()
                .padding(.horizontal, 18)
            
            CarPull.CardView(carPull: .init(id: 4, pickupLocation: "봉천역 2번 출구에서 출발할게요~", periodType: .once, money: 48000, content: "월수금만 카풀하실 분 구합니다. 봉천역 2번출구에서 픽업할 예정이고 시간약속 잘지키시면 좋을 것 같습니다! 비용은 제시해주셔도 됩니다.", moodType: .quiet, companyName: "현대자동차", gender: .male, createdAt: Date()))
        }

    }

    
    private var requestAcceptButton: some View {
        Button { 
            
        }
        label: { Text("요청승인") }
        .buttonStyle(
            .fullCar(
                font: .pretendard17(.bold),
                horizontalPadding: 85,
                verticalPadding: 17,
                radius: 8,
                style: .palette(.primary_white)
            )
        )
    }
    
    private var requestDisableButton: some View {
        Button { }
        label: { Text("요청거절") }
        .buttonStyle(
            .fullCar(
                font: .pretendard17(.bold),
                horizontalPadding: 20,
                verticalPadding: 17,
                radius: 8,
                style: .palette(.gray60)
            )
        )
    }
}

#Preview {
    CallListDetailView(viewModel: .init())
}
