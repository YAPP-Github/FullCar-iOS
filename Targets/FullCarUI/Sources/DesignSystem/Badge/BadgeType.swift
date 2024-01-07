//
//  BadgeType.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// Badge를 구성하는 Style과 Configurable 타입
protocol BadgeStyleConfiguration {
    var icon: Image? { get }
    var configurable: BadgeConfigurable { get }
    var style: ColorStyle { get }
}

extension BadgeStyleConfiguration {
    var icon: Image? { return nil }
    var configurable: BadgeConfigurable { return .standard }
}

/// 게시글의 상태값
public enum PostState: String, BadgeStyleConfiguration {
    /// 모집중
    case recruite = "모집중"
    /// 요청중
    case request = "요청중"
    /// 마감
    case close = "마감"

    var style: ColorStyle {
        switch self {
        case .recruite, .request: return .palette(.primary_secondary)
        case .close: return .palette(.gray60)
        }
    }
}

/// 카풀 매칭 결과
public enum Matching: String, BadgeStyleConfiguration {
    /// 매칭 성공
    case success = "매칭 성공"
    /// 매칭 취소
    case cancel = "매칭 취소"

    var style: ColorStyle {
        switch self {
        case .success: return .palette(.green)
        case .cancel: return .palette(.red)
        }
    }
}

/// 운전자의 정보
public enum Driver {
    case gender(Gender)
    case mood(Mood)

    public enum Gender: String {
        /// 여성 운전자
        case female = "여성 운전자"
        /// 남성 운전자
        case male = "남성 운전자"
    }

    public enum Mood: String {
        /// 조용히 가기
        case quiet = "조용히 가기"
        /// 대화하며 가기
        case talk = "대화하며 가기"
    }
}

extension Driver.Gender: BadgeStyleConfiguration {
    var icon: Image? {
        switch self {
        case .female: return Icon.image(type: .female)
        case .male: return Icon.image(type: .male)
        }
    }

    var configurable: BadgeConfigurable {
        var configurable: BadgeConfigurable = .standard
        configurable.font = .semibold12
        configurable.iconSpacing = 2
        return configurable
    }

    var style: ColorStyle { return .palette(.gray60) }
}

extension Driver.Mood: BadgeStyleConfiguration {
    var icon: Image? {
        switch self {
        case .quiet: return Icon.image(type: .quite)
        case .talk: return Icon.image(type: .talk)
        }
    }

    var configurable: BadgeConfigurable {
        var configurable: BadgeConfigurable = .standard
        configurable.font = .semibold12
        configurable.iconSpacing = 4
        return configurable
    }

    var style: ColorStyle { return .palette(.gray60) }
}
