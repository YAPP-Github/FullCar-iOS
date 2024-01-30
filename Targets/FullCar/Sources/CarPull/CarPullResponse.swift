//
//  CarPullResponse.swift
//  FullCar
//
//  Created by 한상진 on 1/20/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarUI

extension CarPull.Model {
    struct Response: Decodable, Identifiable, Hashable {
        let id: Int
        let pickupLocation: String
        let periodType: String // TODO: enum으로
        let money: Int
        let content: String
        let moodType: Driver.Mood
        let companyName: String
        let gender: Driver.Gender
        let createdAt: Date
    }
}

#if DEBUG
extension CarPull.Model.Response {
    static func mock(with id: Int = Int.random(in: 0...100000)) -> Self {
        return .init(
            id: id,
            pickupLocation: "서울대입구",
            periodType: "ONCE",
            money: 10000,
            content: "월수금만 카풀하실 분 구합니다. 봉천역 2번출구에서 픽업할 예정이고 시간약속 잘지키시면 좋을것 같아···",
            moodType: .quiet,
            companyName: "카카오페이",
            gender: .female,
            createdAt: .now
        )
    }
}
#endif
