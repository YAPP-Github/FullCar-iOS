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

struct CallListDeatilView: View {
    
    @State var toggleOpen: Bool = false
    @State var toggleRotate: CGFloat = 0
    
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
                NavigationButton(icon: .back, action: { })
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
                    toggleOpen.toggle()
                }
                
                withAnimation(.smooth) {
                    
                    toggleRotate += 180
                }
            }, label: {
                HStack(spacing: 0) {
                    
                    Text("카풀 상세")
                        .font(.pretendard17(.bold))
                        .foregroundStyle(Color.black80)
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(toggleRotate))
                        .foregroundStyle(Color.black80)
                }
                .padding(.all, 20)
            })
            
            if toggleOpen {
                
                CarPull.CardView(carPull: .init(companyName: "카카오페이", title: "타이틀", description: "설명", driver: .init(gender: .female, mood: .quiet), postState: .recruite))
                
                Rectangle()
                    .foregroundStyle(Color.gray10)
                    .frame(height: 8, alignment: .center)
                
                Car.InformationCardView(information: .init(number: "23루 3334", model: "SUV", manufacturer: "볼보", color: "화이트"))
            } else {
                Rectangle()
                    .foregroundStyle(Color.gray10)
                    .frame(height: 8, alignment: .center)
            }
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
            
            CarPull.CardView(carPull: .init(companyName: "카카오페이", title: "타이틀", description: "설명", driver: nil, postState: nil))
        }

    }

    
    private var requestAcceptButton: some View {
        Button { }
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
    CallListDeatilView()
}
