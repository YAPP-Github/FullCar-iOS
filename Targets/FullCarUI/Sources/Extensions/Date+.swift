//
//  Date+.swift
//  FullCarUI
//
//  Created by Tabber on 2024/02/10.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

extension Date {
    public func toLocalTime(dateFormatter: String = "MM월 dd일") -> String {
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = dateFormatter
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        
        let convert = myDateFormatter.string(from: self)
        
        return convert
    }
}
