//
//  LoginStyle.swift
//  FullCarUI
//
//  Created by Sunny on 1/15/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

public enum LoginStyle {
    case kakao
    case apple
}

public extension LoginStyle {
    var title: String {
        switch self {
        case .kakao: return "카카오 로그인"
        case .apple: return "Apple로 로그인"
        }
    }

    var icon: Image {
        switch self {
        case .kakao: return Image(icon: .kakaoLogo)
        case .apple: return Image(icon: .appleLogo)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .kakao: return Color(cgColor: UIColor(hex: "FEE500").cgColor)
        case .apple: return .black
        }
    }

    var fontColor: Color {
        switch self {
        case .kakao: return Color(cgColor: UIColor(hex: "392020").cgColor)
        case .apple: return .white
        }
    }
}

