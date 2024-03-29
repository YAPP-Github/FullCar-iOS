//
//  FCIcon.Symbol.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public struct FCIcon { }

public extension FCIcon {
    enum Size: CGFloat {
        case _0 = 0
        case _16 = 16
        case _20 = 20
        case _24 = 24
        case _32 = 32
    }

    enum Symbol {
        case user
        case quite
        case talk
        case check
        case back
        case menu
        case navigationLogo
        case homeLogo
        case kakaoLogo
        case appleLogo
        case messageText
        case resultSuccess
        case resultDenied
        case search
        case location
        case car_gray
        case car
        case chevron_right
        case userCard
        case chat
        case shield_check
        case setting
    }
}

extension FCIcon.Symbol {
    public var name: String {
        switch self {
        case .user: return "user"
        case .quite: return "quite"
        case .talk: return "talk"
        case .back: return "chevron_Left"
        case .menu: return "menu"
        case .navigationLogo: return "navigationLogo"
        case .homeLogo: return "homeLogo"
        case .kakaoLogo: return "kakaoLogo"
        case .messageText: return "message-text"
        case .resultSuccess: return "resultSuccess"
        case .resultDenied: return "resultDenied"
        case .location: return "location"
        case .car_gray: return "car_gray"
        case .car: return "car"
        case .userCard: return "userCard"
        case .chat: return "chat"
        case .shield_check: return "shield_Check"
        case .setting: return "setting"
        default: return ""
        }
    }

    public var systemName: String {
        switch self {
        case .check: return "checkmark.circle.fill"
        case .appleLogo: return "apple.logo"
        case .search: return "magnifyingglass"
        case .chevron_right: return "chevron.right"
        default: return ""
        }
    }
}

