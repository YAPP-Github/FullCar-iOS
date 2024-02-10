//
//  CallListViewModel.swift
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
final class CallListViewModel {
    var selection: FullCar.CallListTab = .request
    
    enum Destination: Hashable {
        case detail(CallListDetailViewModel)
    }
    
    var paths: [Destination] = []
    
    var dummyData: [CarPull.Model.Information] = [
        .init(id: 0,
              pickupLocation: "봉천역",
              periodType: .oneWeek,
              money: 10000,
              content: "봉천역에서 카풀해요~",
              moodType: .quiet,
              formState: .REQUEST,
              carpoolState: .OPEN,
              nickname: "알뜰한 물개",
              companyName: "현대자동차",
              gender: .male,
              resultMessage: .init(contact: "탑승자에게 보내는 메시지", toPassenger: "연락은 카톡으로 드리겠습니다~\n내일 뵙겠습니다."),
              createdAt: Date()),
        .init(id: 1,
              pickupLocation: "봉천역",
              periodType: .oneWeek,
              money: 10000,
              content: "봉천역에서 카풀해요~",
              moodType: .quiet,
              formState: .REJECT,
              carpoolState: .OPEN,
              nickname: "알뜰한 물개",
              companyName: "현대자동차",
              gender: .male,
              resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
              createdAt: Date()),
        .init(id: 2,
              pickupLocation: "봉천역",
              periodType: .oneWeek,
              money: 10000,
              content: "봉천역에서 카풀해요~",
              moodType: .quiet,
              formState: .REQUEST,
              carpoolState: .OPEN,
              nickname: "알뜰한 물개",
              companyName: "현대자동차",
              gender: .male,
              resultMessage: nil,
              createdAt: Date()),
        .init(id: 3,
              pickupLocation: "봉천역",
              periodType: .oneWeek,
              money: 10000,
              content: "봉천역에서 카풀해요~",
              moodType: .quiet,
              formState: .ACCEPT,
              carpoolState: .OPEN,
              nickname: "알뜰한 물개",
              companyName: "현대자동차",
              gender: .male,
              resultMessage: nil,
              createdAt: Date()),
        .init(id: 4,
              pickupLocation: "봉천역",
              periodType: .oneWeek,
              money: 10000,
              content: "봉천역에서 카풀해요~",
              moodType: .quiet,
              formState: .REJECT,
              carpoolState: .OPEN,
              nickname: "알뜰한 물개",
              companyName: "현대자동차",
              gender: .male,
              resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
              createdAt: Date()),
        .init(id: 5,
              pickupLocation: "봉천역",
              periodType: .oneWeek,
              money: 10000,
              content: "봉천역에서 카풀해요~",
              moodType: .quiet,
              formState: .ACCEPT,
              carpoolState: .OPEN,
              nickname: "알뜰한 물개",
              companyName: "현대자동차",
              gender: .male,
              resultMessage: .init(contact: "탑승자에게 보내는 메시지", toPassenger: "연락은 카톡으로 드리겠습니다~\n내일 뵙겠습니다."),
              createdAt: Date())
    ]
    
    
    func onAcceptTapped(type: CallListDetailView.CallListDetailViewType, data: CarPull.Model.Information) {
        guard paths.isEmpty else { return }
        let callListDtailViewModel = CallListDetailViewModel(callListDetailViewType: type, carPullData: data)
        
        callListDtailViewModel.onBackButtonTapped = { [weak self] in
            self?.paths.removeAll()
        }
        
        paths.append(.detail(callListDtailViewModel))
    }
}
