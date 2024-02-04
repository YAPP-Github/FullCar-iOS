//
//  BadgeType.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 게시글의 상태값
public enum PostState: String, Decodable {
    /// 모집중
    case recruite = "모집중"
    /// 요청중
    case request = "요청중"
    /// 마감
    case close = "마감"
}

public extension PostState {
    var style: ColorStyle {
        switch self {
        case .recruite, .request: return .palette(.primary_secondary)
        case .close: return .palette(.gray60)
        }
    }
}

/// 카풀 매칭 결과
public enum Matching: String {
    /// 매칭 성공
    case success = "매칭 성공"
    /// 매칭 취소
    case cancel = "매칭 취소"
}

public extension Matching {
    var style: ColorStyle {
        switch self {
        case .success: return .palette(.green)
        case .cancel: return .palette(.red)
        }
    }
}

/// 운전자의 정보
public struct Driver: Decodable {
    public var gender: Gender
    public var mood: Mood
    
    public init(gender: Gender, mood: Mood) {
        self.gender = gender
        self.mood = mood
    }

    /// 운전자의 성별 타입
    public enum Gender: String, Decodable {
        /// 여성 운전자
        case female = "여성 운전자"
        /// 남성 운전자
        case male = "남성 운전자"
    }

    /// 운전자의 운행분위기 타입
    public enum Mood: String, Decodable, CaseIterable, Identifiable, CustomStringConvertible {
        public var id: Self { return self }
        
        /// 조용히 가기
        case quiet = "조용히 가기"
        /// 대화하며 가기
        case talk = "대화하며 가기"
        
        // FIXME: 수정하기
        public var description: String {
            switch self {
            case .quiet: "CHATTY"
            case .talk: "CHATTY"
            }
        }
    }
}

extension Driver {
    enum BadgeStyle {
        static var font: Pretendard.Style { return .pretendard12(.semibold) }

        static var iconColor: Color { return .gray60 }

        static var iconSize: FCIcon.Size { return ._16 }

        static var style: ColorStyle { return .palette(.gray60) }
    }
}

public extension Driver.Gender {
    var spacing: CGFloat { return 2 }

    var icon: FCIcon.Symbol { return .user }
}

public extension Driver.Mood {
    var spacing: CGFloat { return 4 }

    var icon: FCIcon.Symbol {
        switch self {
        case .quiet: return .quite
        case .talk: return .talk
        }
    }
}
