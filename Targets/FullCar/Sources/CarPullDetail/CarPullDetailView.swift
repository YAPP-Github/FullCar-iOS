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
                Button(viewModel.openType == .Home ? "신고하기" : "삭제하기", role: .destructive) {
                    viewModel.alertOpen = true
                }
            }
            .alert(isPresented: $viewModel.deleteDoneAlertOpen) {
                       Alert(title: Text("카풀 게시글이 삭제되었습니다."),
                             message: nil,
                             dismissButton: .default(Text("닫기"), action: {
                           viewModel.onBackButtonTapped()
                       }))
                   }
            .alert("카풀을 마강하시겠어요?", isPresented: $viewModel.isFinishedAlertOpen, actions: {
                Button(role: .destructive, action: {
                    Task { await viewModel.patchAction(id: viewModel.carPull.id) }
                }, label: {
                    Text("마감하기")
                })
            })
            .alert(viewModel.openType == .Home ? "카풀 게시글을 신고하시겠어요?" : "카풀을 삭제 하시겠어요?", isPresented: $viewModel.alertOpen, actions: {
                Button(role: .destructive, action: {
                    switch viewModel.openType {
                    case .MyPage:
                        Task { await viewModel.deleteAction(id: viewModel.carPull.id) }
                    case .Home:
                        //Task { await }
                        break
                    }
                }, label: {
                    Text(viewModel.openType == .Home ? "신고하기" : "삭제하기")
                })
            }, message: {
                Text(viewModel.openType == .Home ? "게시글 신고시 어쩌구 저쩌구 됩니다." : "카풀 삭제 시 복구가 불가능하며\n모든 요청이 거절 처리됩니다.")
            })
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
                
                if viewModel.requestStatus == .inProcess {
                    Text("희망 접선 장소 해야함")
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var beginRequestButton: some View {
        Button {
            switch viewModel.openType {
            case .MyPage:
                viewModel.isFinishedAlertOpen = true
            case .Home:
                Task { await viewModel.beginRequestButtonTapped() }
            }
        }
    label: { Text(viewModel.openType == .Home ? "탑승요청" : "마감하기") }
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
