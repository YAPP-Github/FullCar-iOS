//
//  CarPullDetailView.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

@MainActor
struct CarPullDetailView: View {
    @Bindable var viewModel: CarPullDetailViewModel
    
    var body: some View {
        _body
            .onFirstTask {
                await viewModel.onFirstTask()
            }
            .navigationBarStyle(
                leadingView: { 
                    Button {
                        viewModel.onBackButtonTapped()
                    } label: {
                        Image(icon: .back)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                            .frame(width: 24, height: 24)
                    }
                }, centerView: { 
                    Text("카풀 상세")
                        .font(.pretendard18(.bold))
                }, trailingView: { 
                    Button {
                        viewModel.actionSheetOpen = true
                    } label: {
                        Image(icon: .menu)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                            .frame(width: 24, height: 24)
                    }
                }
            )
            .confirmationDialog("", isPresented: $viewModel.actionSheetOpen, titleVisibility: .hidden) {
                Button("삭제", role: .destructive) {
                    viewModel.alertOpen = true
                }
            }
            .alert("카풀을 삭제 하시겠어요?", isPresented: $viewModel.alertOpen, actions: {
                Button(role: .destructive, action: {
                    viewModel.deleteDoneOpen = true
                }, label: {
                    Text("삭제하기")
                })
            }, message: {
                Text("카풀 삭제 시 복구가 불가능하며\n모든 요청이 거절 처리됩니다.")
            })
            .alert("카풀 게시글이 삭제되었습니다.",
                   isPresented: $viewModel.deleteDoneOpen , actions: {})
            .background(Color.white)
            
    }
    
    private var _body: some View {
        VStack(spacing: .zero) {
            contentView
            Spacer()
            beginRequestButton
                .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var contentView: some View {
        ScrollView(.vertical) {
            VStack(spacing: .zero) {
                CarPull.CardView(carPull: viewModel.carPull)
                
                Color.gray10.frame(height: 8)
                
                if let information = viewModel.information {
                    Car.InformationCardView(information: information)
                }
                
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var beginRequestButton: some View {
        Button {
            
        }
        label: { Text("마감하기") }
        .buttonStyle(
            .fullCar(
                font: .pretendard17(.bold),
                horizontalPadding: 137,
                verticalPadding: 17,
                radius: 8,
                style: .palette(viewModel.requestStatus == .applyAlready ? .gray60 : .primary_white)
            )
        )
        .disabled(viewModel.requestStatus == .applyAlready)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        CarPullDetailView(
            viewModel: .init(
                requestStatus: .beforeBegin,
                carPull: .mock()
            )
        )
    }
}
#endif
