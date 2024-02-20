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
    
    @Bindable var viewModel: CallListDetailViewModel
    
    var body: some View {
        _body
            .navigationBarStyle(
                leadingView: {
                    NavigationButton(icon: .back, action: {
                        viewModel.onBackButtonTapped()
                    })
                },
                centerView: {
                    switch viewModel.callListDetailViewType {
                    case .SentRequestDetails, .ReceivedRequestDetails:
                        Text("요청 상세")
                            .font(.pretendard18(.bold))
                    case .CallPullDeatils:
                        Text("카풀 상세")
                            .font(.pretendard18(.bold))
                    }
                },
                trailingView: { }
            )
            .fullScreenCover(isPresented: $viewModel.fullSheetOpen, onDismiss: {
                viewModel.onBackButtonTapped()
            }, content: {
                CallResultView(type: viewModel.carPullResultType)
            })
            .alert("요청을 거절 하시겠어요?", isPresented: $viewModel.alertOpen, actions: {
                
                Button(role: .destructive, action: {
                    
                    Task {
                        await viewModel.changeState(.REJECT)
                        await MainActor.run {
                            viewModel.carPullResultType = .denied
                            viewModel.fullSheetOpen = true
                        }
                    }
                    
                }, label: {
                    Text("거절하기")
                })
            })
            .task {
                await viewModel.loadData()
            }
    }
    
    private var _body: some View {
        VStack(spacing: 0) {
            
            ScrollViewReader { reader in
                ScrollView {
                    toggleView
                    requestView(reader)
                }
            }
            
            switch viewModel.callListDetailViewType {
            case .ReceivedRequestDetails:
                HStack {
                    
                    if viewModel.typingState != .typing {
                        requestDisableButton
                    }
                    
                    requestAcceptButton
                }
            case .CallPullDeatils:
                requestAcceptButton
            default: EmptyView()
            }
            
        }
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
                    
                    switch viewModel.callListDetailViewType {
                    // 보낸 요청 상세
                    case .SentRequestDetails:
                        Text("카풀 상세")
                            .font(.pretendard17(.bold))
                            .foregroundStyle(Color.black80)
                    // 받은 요청 상세
                    case .ReceivedRequestDetails:
                        Text("내가 등록한 카풀")
                            .font(.pretendard17(.bold))
                            .foregroundStyle(Color.black80)
                    // 카풀 상세
                    default: EmptyView()
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(viewModel.toggleRotate))
                        .foregroundStyle(Color.black80)
                }
                .padding(.all, 20)
            })
            
            if viewModel.toggleOpen {
                
                CarPull.CardView(carPull: viewModel.carpullData)
                
                Rectangle()
                    .foregroundStyle(Color.gray10)
                    .frame(height: 8, alignment: .center)
                
                if let _ = viewModel.carpullData.carNo {
                    let carpullData = viewModel.carpullData
                    Car.InformationCardView(information: .init(id: Int(carpullData.id),
                                                               carNumber: carpullData.carNo ?? "",
                                                               carName: carpullData.carName ?? "",
                                                               carBrand: carpullData.carBrand ?? "",
                                                               carColor: carpullData.carColor ?? ""))
                }
            }
            
            Rectangle()
                .foregroundStyle(Color.gray10)
                .frame(height: 8, alignment: .center)
        }
    }
    
    private func requestView(_ reader: ScrollViewProxy) -> some View {
        
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                switch viewModel.callListDetailViewType {
                case .SentRequestDetails:
                    Text("요청한 내역")
                        .font(.pretendard17(.bold))
                        .foregroundStyle(Color.black80)
                case .ReceivedRequestDetails:
                    Text("요청받은 내역")
                        .font(.pretendard17(.bold))
                        .foregroundStyle(Color.black80)
                case .CallPullDeatils:
                    EmptyView()
                }

                Spacer()
            }
            .padding(.all, 20)
            
            Divider()
                .padding(.horizontal, 18)
            
            CarPull.CardView(carPull: viewModel.carpullData)
            
            switch viewModel.callListDetailViewType {
            case .SentRequestDetails:
                sentRequestDetailReceiveMessageView
            case .ReceivedRequestDetails:
                receivedDetailInputView(reader)
            default:
                EmptyView()
            }
        }

    }
    
    private func receivedDetailInputView(_ reader: ScrollViewProxy) -> some View {
        Group {
            if viewModel.typingState == .typing {
                CarPullAcceptTypingView(viewModel: viewModel)
                    .id("acceptTyping")
                    .task {
                        try? await Task.sleep(for: .seconds(0.5))
                        await MainActor.run {
                            withAnimation {
                                reader.scrollTo("acceptTyping")
                            }
                        }
                    }
            }
        }
    }

    private var sentRequestDetailReceiveMessageView: some View {
        Group {
            switch viewModel.carpullData.formState {
            case .ACCEPT, .REJECT:
                CarPullDeatilDescriptionView(item: viewModel.carpullData)
            default:
                EmptyView()
            }
        }
    }
    
    private var requestAcceptButton: some View {
        Button {
            
            switch viewModel.typingState {
            case .waiting:
                withAnimation(.smooth) {
                    viewModel.typingState = .typing
                }
            case .typing:
                
                Task {
                    await viewModel.changeState(.ACCEPT)
                    await MainActor.run {
                        viewModel.carPullResultType = .success
                        viewModel.fullSheetOpen = true
                    }
                }
            }
        }
    label: { Text(viewModel.typingState == .waiting ? "요청승인" : "완료") }
        .buttonStyle(
            .fullCar(
                font: .pretendard17(.bold),
                horizontalPadding: viewModel.callListDetailViewType == .CallPullDeatils || viewModel.typingState == .typing ? 160 : 85,
                verticalPadding: 17,
                radius: 8,
                style: .palette(viewModel.typingState != .typing ? .primary_white : viewModel.myCallNumber.count > 0 ? .primary_white : .gray60)
            )
        )
        .disabled(viewModel.typingState == .typing && viewModel.myCallNumber.count == 0)
    }
    
    private var requestDisableButton: some View {
        Button {
            viewModel.alertOpen = true
        }
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
