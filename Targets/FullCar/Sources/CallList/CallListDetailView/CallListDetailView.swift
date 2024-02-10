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
                
                CarPull.CardView(carPull: .init(id: 0,
                                                pickupLocation: "봉천역",
                                                periodType: .oneWeek,
                                                money: 1000, content: "타이틀",
                                                moodType: .quiet,
                                                formState: .ACCEPT,
                                                carpoolState: .OPEN,
                                                nickname: "알뜰한 물개",
                                                companyName: "회사이름", gender: .female, resultMessage: nil, createdAt: Date()))
                
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
            withAnimation(.smooth) {
                viewModel.typingState = .typing
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
    CallListDetailView(viewModel: .init(callListDetailViewType: .CallPullDeatils,
                                        carPullData: .init(id: 0,
                                                           pickupLocation: "봉천역",
                                                           periodType: .oneWeek,
                                                           money: 1000, content: "타이틀",
                                                           moodType: .quiet,
                                                           formState: .ACCEPT,
                                                           carpoolState: .OPEN,
                                                           nickname: "알뜰한 물개",
                                                           companyName: "회사이름", gender: .female, resultMessage: nil,
                                                           createdAt: Date())))
}
