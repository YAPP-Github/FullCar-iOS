//
//  CarPullDetailViewModel.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import Observation
import Dependencies
import XCTestDynamicOverlay
import FullCarUI
import SwiftUI



@MainActor
@Observable
final class CarPullDetailViewModel {
    @ObservationIgnored @Dependency(\.callListAPI) private var callListAPI
    
    enum CarPullDetailOpenType {
        case MyPage
        case Home
    }
    
    enum AlertType {
    case alreadyRegister
    case deleteDone
    case apply
    }
    
    enum RequestStatus {
        case beforeBegin
        case inProcess
        case applyAlready
    }
    
    var openType: CarPullDetailOpenType
    var requestStatus: RequestStatus
    let carPull: CarPull.Model.Information
    var information: Car.Information?
    var onBackButtonTapped: () -> Void = unimplemented("onBackButtonTapped")
    
    var actionSheetOpen: Bool = false
    var alertOpen: Bool = false
    var deleteDoneAlertOpen: Bool = false
    var isFinishedAlertOpen: Bool = false
    var acceptAlertOpen: Bool = false
    var alreadyRegisterAlertOpen: Bool = false
    
    var alertType: AlertType = .alreadyRegister
    
    // MARK: 입력 데이터들
    var wishPlaceString: String = ""
    var wishPlaceStringState: InputState = .default
    
    var wishCostText: String = ""
    var wishCostState: InputState = .default
    var periodType: CarPull.Model.PeriodType?
    
    var sendText: String = ""
    
    init(
        openType: CarPullDetailOpenType = .Home,
        requestStatus: RequestStatus = .beforeBegin,
        carPull: CarPull.Model.Information
    ) {
        self.openType = openType
        self.requestStatus = requestStatus
        self.carPull = carPull
    }
    
    func onFirstTask() async {
        // TODO: API call
    }
    
    func beginRequestButtonTapped() async {
        await applyFullCar()
    }
    
    func applyFullCar() async {
        do {
            try await callListAPI.applyCarpull(formId: carPull.id,
                                               pickupLocation: wishPlaceString,
                                               peroidType: periodType?.rawValue ?? "",
                                               money: Int(wishCostText) ?? 0,
                                               content: sendText)
            
            await MainActor.run {
                requestStatus = .applyAlready
                alertType = .apply
                alreadyRegisterAlertOpen = true
            }
        } catch {
            
            alertType = .alreadyRegister
            alreadyRegisterAlertOpen = true
            
            print("error", error.localizedDescription)
        }
    }
    
    func wishCostTextChanged(_ wishCostText: String) {
        if wishCostText.count <= 10 {
            self.wishCostState = .focus
        } else {
            self.wishCostState = .error("희망 비용은 10글자 까지 입력할 수 있어요.")
        }
        self.wishCostText = wishCostText
    }
    
    func periodSelectionButton(period: CarPull.Model.PeriodType) {
        self.periodType = period
    }
    
    func patchAction(id: Int64) async {
        do {
            let _ = try await callListAPI.patchCarpull(formId: id)
            onBackButtonTapped()
        } catch {
            print("error", error.localizedDescription)
        }
    }
    
    func deleteAction(id: Int64) async {
        do {
            let _ = try await callListAPI.deleteCarpull(formId: id)
            
            alertType = .deleteDone
            alreadyRegisterAlertOpen = true
        } catch {
            print("에러", error.localizedDescription)
        }
    }
    
    func checkDisable() -> Bool {
        withAnimation(.smooth(duration: 0.2)) {
            switch requestStatus {
            case .beforeBegin:
                return false
            case .inProcess:
                return ((wishPlaceString.isEmpty) && (wishCostText.isEmpty))
            case .applyAlready:
                return true
            }
        }
    }
    
    func checkStyle() -> ColorStyle {
        switch requestStatus {
        case .beforeBegin:
            return .palette(.primary_white)
        case .inProcess:
            return !(wishPlaceString.isEmpty) && !(wishCostText.isEmpty) ? .palette(.primary_white) : .palette(.gray60)
        case .applyAlready:
            return .palette(.gray60)
        }
    }
}

extension CarPullDetailViewModel: Hashable {
    nonisolated static func == (lhs: CarPullDetailViewModel, rhs: CarPullDetailViewModel) -> Bool {
        return lhs === rhs
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
