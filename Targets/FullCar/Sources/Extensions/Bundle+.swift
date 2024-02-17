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
            return "51faa8ff69b90d38f7b382af470b644f"
        }
        
        return key
    }

    /*
     KAKAO_NATIVE_APP_KEY = 51faa8ff69b90d38f7b382af470b644f
     KAKAO_REST_API_KEY = 1beb7fb6952155736b0d5554eb63ee38
     */
    
    var kakaoRestApiKey: String? {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["KakaoRestApiKey"] as? String else {
            return "1beb7fb6952155736b0d5554eb63ee38"
        }

        return key
    }
}
