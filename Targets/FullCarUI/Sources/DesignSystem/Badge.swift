//
//  Badge.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// 운전자의 정보와 게시글의 상태값을 알려주는 배지입니다.
public struct Badge: View {

    private let type: BadgeType

    private let horizontalPadding: CGFloat = 8
    private let verticalPadding: CGFloat = 5
    private let radius: CGFloat = 3

    public init(type: BadgeType) {
        self.type = type
    }

    public var body: some View {
        HStack(spacing: iconSpacing) {
            icon?
                .resizable()
                .frame(width: 16, height: 16)

            Text(label)
                .font(pretendard: .caption5)
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, horizontalPadding)
        .background(backgroundColor)
        .cornerRadius(radius: radius, corners: .allCorners)
    }

    private var label: String {
        switch type {
        case .recruite: return "모집중"
        case .request: return "요청중"
        case .close: return "마감"
        case .matching_success: return "매칭 성공"
        case .matching_cancel: return "매칭 취소"
        case .driver_female: return "여성 운전자"
        case .driver_male: return "남성 운전자"
        case .driving_quiet: return "조용히 가기"
        case .driving_talk: return "대화하며 가기"
        }
    }

    // 아이콘 이미지 임시
    private var icon: Image? {
        switch type {
        case .driver_female: return .init(systemName: "square.and.arrow.up.circle")
        case .driver_male: return .init(systemName: "square.and.arrow.up.circle")
        case .driving_quiet: return .init(systemName: "square.and.arrow.up.circle")
        case .driving_talk: return .init(systemName: "square.and.arrow.up.circle")

        default: return nil
        }
    }

    private var iconSpacing: CGFloat {
        switch type {
        case .driver_female: return 2
        case .driver_male: return 2
        case .driving_quiet: return 4
        case .driving_talk: return 4

        default: return 0
        }
    }

    private var backgroundColor: Color {
        switch type {
        case .recruite: return .secondary
        case .request: return .secondary
        case .close: return .gray30
        case .matching_success: return .green50
        case .matching_cancel: return .red50
        case .driver_female: return .gray10
        case .driver_male: return .gray10
        case .driving_quiet: return .gray10
        case .driving_talk: return .gray10
        }
    }

    private var textColor: Color {
        switch type {
        case .recruite: return .primary
        case .request: return .primary
        case .close: return .gray60
        case .matching_success: return .green100
        case .matching_cancel: return .red100
        case .driver_female: return .gray60
        case .driver_male: return .gray60
        case .driving_quiet: return .gray60
        case .driving_talk: return .gray60
        }
    }
}

extension Badge {
    public enum BadgeType {
        /// 모집중
        case recruite
        /// 요청중
        case request
        /// 마감
        case close
        /// 매칭 성공
        case matching_success
        /// 매칭 취소
        case matching_cancel
        /// 여성 운전자
        case driver_female
        /// 남성 운전자
        case driver_male
        /// 조용히 가기
        case driving_quiet
        /// 대화하며 가기
        case driving_talk
    }
}

#Preview {
    Badge(type: .close)
}
