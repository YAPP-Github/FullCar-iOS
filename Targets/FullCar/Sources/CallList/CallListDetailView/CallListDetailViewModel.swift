//
//  CallListDetailViewModel.swift
//  FullCar
//
//  Created by Tabber on 2024/02/03.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarKit
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
}

@MainActor
@Observable
final class CallListDetailViewModel {
    
    var callListDetailViewType: CallListDetailView.CallListDetailViewType = .SentRequestDetails
    
    var onBackButtonTapped: () -> Void = unimplemented("onBackButtonTapped")
    
    var toggleOpen: Bool = false
    var toggleRotate: CGFloat = 0
}


extension CallListDetailViewModel: Hashable {
    nonisolated static func == (lhs: CallListDetailViewModel, rhs: CallListDetailViewModel) -> Bool {
        return lhs === rhs
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
