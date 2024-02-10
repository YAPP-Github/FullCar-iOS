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

@MainActor
@Observable
final class CallListDetailViewModel {
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
