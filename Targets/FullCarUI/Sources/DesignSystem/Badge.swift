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

    public init(type: BadgeType) {
        self.type = type
    }

    public var body: some View {
        HStack(spacing: iconSpacing) {
            if let icon = icon {
                icon
                    .resizable()
                    .frame(width: 16, height: 16)
            }

            Text(type.rawValue)
                .font(pretendard: .caption5)
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.verticalPadding)
        .background(backgroundColor)
        .cornerRadius(radius: Constants.radius, corners: .allCorners)
    }
}

extension Badge {
    enum Constants {
        static let horizontalPadding: CGFloat = 8
        static let verticalPadding: CGFloat = 5
        static let radius: CGFloat = 3
    }

    private var icon: Image? {
        switch type {
        case .driver_female: return Icon.image(type: .female)
        case .driver_male: return Icon.image(type: .male)
        case .driving_quiet: return Icon.image(type: .quite)
        case .driving_talk: return Icon.image(type: .talk)

        default: return nil
        }
    }

    private var iconSpacing: CGFloat {
        switch type {
        case .driver_female, .driver_male : return 2
        case .driving_quiet, .driving_talk: return 4
        default: return 0
        }
    }

    private var backgroundColor: Color {
        switch type {
        case .recruite, .request: return .fullCar_secondary
        case .close: return .gray30
        case .matching_success: return .green50
        case .matching_cancel: return .red50
        case .driver_female, .driver_male, .driving_quiet, .driving_talk: return .gray10
        }
    }

    private var textColor: Color {
        switch type {
        case .recruite, .request: return .fullCar_primary
        case .close: return .gray60
        case .matching_success: return .green100
        case .matching_cancel: return .red100
        case .driver_female, .driver_male, .driving_quiet, .driving_talk : return .gray60
        }
    }
}

public extension Badge {
    enum BadgeType: String {
        /// 모집중
        case recruite = "모집중"
        /// 요청중
        case request = "요청중"
        /// 마감
        case close = "마감"
        /// 매칭 성공
        case matching_success = "매칭 성공"
        /// 매칭 취소
        case matching_cancel = "매칭 취소"
        /// 여성 운전자
        case driver_female = "여성 운전자"
        /// 남성 운전자
        case driver_male = "남성 운전자"
        /// 조용히 가기
        case driving_quiet = "조용히 가기"
        /// 대화하며 가기
        case driving_talk = "대화하며 가기"
    }
}

struct BadgePreviews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            VStack {
                Badge(type: .recruite)
                Badge(type: .request)
                Badge(type: .close)
            }

            VStack {
                Badge(type: .matching_success)
                Badge(type: .matching_cancel)
            }

            VStack {
                Badge(type: .driver_female)
                Badge(type: .driver_male)
            }

            VStack {
                Badge(type: .driving_quiet)
                Badge(type: .driving_talk)
            }
        }
    }
}
