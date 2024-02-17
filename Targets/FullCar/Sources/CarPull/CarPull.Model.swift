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
            let id: Double
            let pickupLocation: String
            let periodType: PeriodType
            let money: Int
            let content: String?
            let moodType: Driver.Mood?
            let formState: FormStateType?
            let carpoolState: CarPoolStateType?
            let nickname: String?
            let companyName: String
            let gender: Driver.Gender?
            let resultMessage: ResultMessage?
            let createdAt: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case pickupLocation
                case periodType
                case money
                case content
                case moodType
                case formState
                case carpoolState
                case nickname
                case companyName
                case gender
                case resultMessage
                case createdAt
            }
            
            init(id: Double, pickupLocation: String, periodType: PeriodType, money: Int, content: String, moodType: Driver.Mood?, formState: FormStateType?, carpoolState: CarPoolStateType?, nickname: String?, companyName: String, gender: Driver.Gender?, resultMessage: ResultMessage?, createdAt: Date) {
                self.id = id
                self.pickupLocation = pickupLocation
                self.periodType = periodType
                self.money = money
                self.content = content
                self.moodType = moodType
                self.formState = formState
                self.carpoolState = carpoolState
                self.nickname = nickname
                self.companyName = companyName
                self.gender = gender
                self.resultMessage = resultMessage
                self.createdAt = createdAt.toString()
            }
            
            
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decode(Double.self, forKey: .id)
                self.pickupLocation = try container.decode(String.self, forKey: .pickupLocation)
                self.periodType = try container.decode(PeriodType.self, forKey: .periodType)
                self.money = try container.decode(Int.self, forKey: .money)
                self.content = try? container.decode(String?.self, forKey: .content) ?? nil
                self.moodType = try? container.decode(Driver.Mood?.self, forKey: .moodType) ?? .none
                self.formState = try? container.decode(FormStateType?.self, forKey: .formState) ?? .none
                self.carpoolState = try? container.decode(CarPoolStateType?.self, forKey: .carpoolState) ?? .none
                self.nickname = try? container.decode(String?.self, forKey: .nickname) ?? nil
                self.companyName = try container.decode(String.self, forKey: .companyName)
                self.gender = try? container.decode(Driver.Gender?.self, forKey: .gender) ?? .none
                self.resultMessage = try? container.decode(ResultMessage?.self, forKey: .resultMessage) ?? .none
                self.createdAt = try container.decode(String.self, forKey: .createdAt)
            }
        }
        
        struct ResultMessage: Decodable, Hashable {
            let contact: String
            let toPassenger: String?
        }
        
        enum FormStateType: String, Decodable, CaseIterable, CustomStringConvertible {
            case REQUEST = "REQUEST"
            case ACCEPT = "ACCEPT"
            case REJECT = "REJECT"
            
            var description: String {
                switch self {
                case .ACCEPT: "매칭 성공"
                case .REJECT: "매칭 취소"
                case .REQUEST: "요청중"
                }
            }
        }
        
        enum CarPoolStateType: String, Decodable, CaseIterable, CustomStringConvertible {
            case OPEN = "OPEN"
            case CLOSE = "CLOSE"
            
            var description: String {
                switch self {
                case .OPEN:
                    return "OPEN"
                case .CLOSE:
                    return "CLOSE"
                }
            }
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
    }
}

#if DEBUG
extension CarPull.Model.Information {
    static func mock(with id: Double = Double.random(in: 0...100000)) -> Self {
        return .init(
            id: id,
            pickupLocation: "서울대입구",
            periodType: CarPull.Model.PeriodType(rawValue: "ONCE") ?? .once,
            money: 10000,
            content: "월수금만 카풀하실 분 구합니다. 봉천역 2번출구에서 픽업할 예정이고 시간약속 잘지키시면 좋을것 같아···",
            moodType: .quiet,
            formState: .ACCEPT,
            carpoolState: .OPEN,
            nickname: "",
            companyName: "카카오페이",
            gender: .female,
            resultMessage: nil,
            createdAt: .now
        )
    }
}
#endif
