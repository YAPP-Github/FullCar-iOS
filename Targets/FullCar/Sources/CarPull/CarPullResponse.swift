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
    struct Response: Decodable, Identifiable {
        var id: UUID = .init()
        let companyName: String
        let title: String
        let description: String
        let driver: Driver
        let postState: PostState
    }
}

#if DEBUG
extension CarPull.Model.Response {
    static var mock: Self = .init(
        companyName: "카카오페이",
        title: "판교역 10시 도착",
        description: "월수금만 카풀하실 분 구합니다. 봉천역 2번출구에서 픽업할 예정이고 시간약속 잘지키시면 좋을것 같아···",
        driver: .init(gender: .female, mood: .quiet),
        postState: .recruite
    )
}
#endif
