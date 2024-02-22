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
            .alert(isPresented: $viewModel.alreadyRegisterAlertOpen) {
                
                switch viewModel.alertType {
                case .alreadyRegister:
                    Alert(title: Text("이미 신청한 카풀이거나, 탈퇴한 유저의 카풀입니다."),
                          message: nil,
                          dismissButton: .default(Text("닫기"), action: {
                        viewModel.onBackButtonTapped()
                    }))
                case .deleteDone:
                    Alert(title: Text(viewModel.openType == .MyPage ? "카풀 게시글이 삭제되었습니다." : "신고 완료되었습니다."),
                          message: nil,
                          dismissButton: .default(Text("닫기"), action: {
                        viewModel.onBackButtonTapped()
                    }))
                case .apply:
                    Alert(title: Text("탑승 요청이 완료되었습니다."),
                          message: nil,
                          dismissButton: .default(Text("닫기"), action: {
                        viewModel.onBackButtonTapped()
                    }))
                }
            }
            .alert("카풀을 마감하시겠어요?", isPresented: $viewModel.isFinishedAlertOpen, actions: {
                Button(role: .destructive, action: {
                    Task { await viewModel.patchAction(id: viewModel.carPull.id) }
                }, label: {
                    Text("마감하기")
                })
            })
            .alert(viewModel.openType == .Home ? "카풀 게시글을 신고하시겠어요?" : "카풀을 삭제 하시겠어요?", isPresented: $viewModel.alertOpen, actions: {
                Button(role: .destructive, action: {
                    switch viewModel.openType {
                    case .Home:
                        viewModel.deleteDoneAlertOpen = true
                    case .MyPage:
                        Task { await viewModel.deleteAction(id: viewModel.carPull.id) }
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
                    VStack(spacing: .zero) {
                        wishPlaceTextField
                        wishCostTextField
                        wishSayTextField
                    }
                    .padding(.all, 20)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var wishPlaceTextField: some View {
        FCTextFieldView(
            textField: {
                TextField("ex) 삼성역 5번 출구", text: $viewModel.wishPlaceString)
                    .textFieldStyle(
                        .fullCar(state: $viewModel.wishPlaceStringState, padding: 16)
                    )
            },
            state: $viewModel.wishPlaceStringState,
            headerText: "희망 접선 장소",
            isHeaderRequired: true
        )
        .padding(.bottom, 28)
    }
    
    private var wishCostTextField: some View {
        SectionView {
            FCTextFieldView(
                textField: { periodSelectionView },
                state: $viewModel.wishCostState
            )
        } header: {
            HeaderLabel(
                title: "희망 비용",
                isRequired: true,
                font: .pretendard16(.semibold)
            )
        }
        .padding(.bottom, 36)
    }
    
    private var wishSayTextField: some View {
        Group {
            HeaderLabel(
                title: "운전자에게 전할 말",
                isRequired: false,
                font: .pretendard16(.semibold)
            )
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            FCTextEditor(
                text: $viewModel.sendText,
                placeholder: "운전자에게 하고 싶은 말이 있다면 자유롭게 작성해주세요!",
                font: .pretendard16(.semibold),
                padding: 16,
                radius: 10
            )
            .frame(height: 150)
        }
    }
    
    private var periodSelectionView: some View {
        HStack(spacing: .zero) {
            periodSelectionButton
                .padding(.trailing, 12)
            
            TextField(
                "ex) 30,000",
                text: .init(
                    get: { viewModel.wishCostText },
                    set: { viewModel.wishCostTextChanged($0) }
                )
            )
            .keyboardType(.numberPad)
            .textFieldStyle(
                .fullCar(
                    type: .won,
                    state: $viewModel.wishCostState
                )
            )
        }
    }
    
    private var periodSelectionButton: some View {
        Menu {
            ForEach(CarPull.Model.PeriodType.allCases, id: \.self) { period in
                Button {
                    viewModel.periodSelectionButton(period: period)
                } label: {
                    Text(period.description)
                }
            }
        } label: {
            HStack(spacing: .zero) {
                Text(viewModel.periodType?.description ?? "기간")
                    .font(.pretendard16(.semibold))
                    .foregroundStyle(viewModel.periodType == nil ? Color.gray45 : Color.black80)
                    .padding(.trailing, 8)
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.black80)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color.gray30)
            }
        }
    }
    
    
    private var beginRequestButton: some View {
        Button {
            switch viewModel.openType {
            case .MyPage:
                viewModel.isFinishedAlertOpen = true
            case .Home:
                
                switch viewModel.requestStatus {
                case .beforeBegin:
                    withAnimation(.smooth(duration: 0.2)) {
                        viewModel.requestStatus = .inProcess
                    }
                case .inProcess:
                    Task { await viewModel.beginRequestButtonTapped() }
                case .applyAlready:
                    break
                }
            }
        }
    label: { Text(viewModel.openType == .Home ? viewModel.requestStatus == .beforeBegin ? "탑승요청" : "요청하기" : "마감하기") }
        .buttonStyle(
            .fullCar(
                font: .pretendard17(.bold),
                horizontalPadding: 137,
                verticalPadding: 17,
                radius: 8,
                style: viewModel.checkStyle()
            )
        )
        .disabled(viewModel.checkDisable())
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
