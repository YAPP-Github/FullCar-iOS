//
//  CallListDetailViewModel.swift
//  FullCar
//
//  Created by Tabber on 2024/02/03.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarKit
import FullCarUI
import Observation
import Dependencies

extension CallListDetailView {
    enum CallListDetailViewType {
    /// 보낸 요청 상세
    case SentRequestDetails
    /// 받은 요청 상세
    case ReceivedRequestDetails
    /// 카풀 상세
    case CallPullDeatils
    }
    
    enum TypingState {
    case waiting
    case typing
    }
}

@MainActor
@Observable
final class CallListDetailViewModel {
    @ObservationIgnored @Dependency(\.callListAPI) private var callListAPI
    var callListDetailViewType: CallListDetailView.CallListDetailViewType = .SentRequestDetails
    
    var onBackButtonTapped: () -> Void = unimplemented("onBackButtonTapped")
    
    var toggleOpen: Bool = false
    
    var toggleRotate: CGFloat = 0
    
    var carpullData: CarPull.Model.Information
    var requestCarpoolData: CarPull.Model.Information? = nil
    
    var typingState: CallListDetailView.TypingState = .waiting
    
    var fullSheetOpen: Bool = false
    
    var carPullResultType: CallResultView.CallResultType = .success
    var alertOpen: Bool = false
    
    // 요청승인시 사용하는 데이터들
    var myCallNumber: String = ""
    var myCallNumberState: InputState = .default
    var sendText: String = ""
    var sendTextState: InputState = .default
    
    init(callListDetailViewType: CallListDetailView.CallListDetailViewType, carPullData: CarPull.Model.Information) {
        self.callListDetailViewType = callListDetailViewType
        self.carpullData = carPullData
    }
    
    func loadData() async {
        do {
            let receiveData = try await callListAPI.getFormDetail(formId: carpullData.id)
            let carpoolData = try await callListAPI.getCarpoolDetail(id: receiveData.data.carpoolId ?? 0)
            
            self.carpullData = receiveData.data
            self.requestCarpoolData = carpoolData.data
            
        } catch {
            print("error", error.localizedDescription)
        }
    }
    
    func changeState(_ state: CarPull.Model.FormStateType) async {
        do {
            try await callListAPI.changeFormState(formId: carpullData.id, state: state, contact: myCallNumber, toPassenger: sendText.isEmpty ? nil : sendText)
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension CallListDetailViewModel: Hashable {
    nonisolated static func == (lhs: CallListDetailViewModel, rhs: CallListDetailViewModel) -> Bool {
        return lhs === rhs
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
