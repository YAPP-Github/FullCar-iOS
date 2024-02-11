//
//  Bundle+.swift
//  FullCar
//
//  Created by Sunny on 12/18/23.
//  Copyright © 2023 FullCar Corp. All rights reserved.
//

import Foundation

extension Bundle {
    var kakaoNativeAppKey: String? {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["KakaoNativeAppKey"] as? String else {
            return nil
        }
        
        return key
    }

    var kakaoRestApiKey: String? {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["KakaoRestApiKey"] as? String else {
            return nil
        }

        return key
    }
}
