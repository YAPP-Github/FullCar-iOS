//
//  CarPullResponse.swift
//  FullCar
//
//  Created by 한상진 on 1/20/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import FullCarUI

extension CarPull {
    enum Model {
        struct Fetch: Decodable {
            let size: Int
            let carPullList: [CarPull.Model.Information]
            private enum CodingKeys: String, CodingKey {
                case size
                case carPullList = "content"
            }
        }
        
        struct Information: Decodable, Identifiable, Hashable {
            let id: Int
            let pickupLocation: String
            let periodType: PeriodType
            let money: Int
            let content: String
            let moodType: Driver.Mood?
            let companyName: String
            let gender: Driver.Gender?
            let createdAt: Date
        }
        
        enum PeriodType: String, Decodable, CaseIterable, CustomStringConvertible {
            case once = "ONCE"
            case oneWeek = "ONE_WEEK"
            case twoWeek = "TWO_WEEK"
            case threeWeek = "THREE_WEEK"
            case fourWeek = "FOUR_WEEK"
            
            var description: String {
                switch self {
                case .once: return "1회"
                case .oneWeek: return "1주"
                case .twoWeek: return "2주"
                case .threeWeek: return "3주"
                case .fourWeek: return "4주"
                }
            }
        }
        
        enum CarPullState: String, Decodable {
            case open = "OPEN"
            case close = "CLOSE"
        }
    }
}

#if DEBUG
extension CarPull.Model.Information {
    static func mock(with id: Int = Int.random(in: 0...100000)) -> Self {
        return .init(
            id: id,
            pickupLocation: "서울대입구",
            periodType: CarPull.Model.PeriodType(rawValue: "ONCE") ?? .once,
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
