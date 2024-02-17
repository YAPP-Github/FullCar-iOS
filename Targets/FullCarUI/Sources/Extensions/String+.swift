//
//  String+.swift
//  FullCarUI
//
//  Created by Tabber on 2024/02/17.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

extension String {
    public func toDate(dateFormat: String = "MM월 dd일") -> String {
        let dateFormatter = DateFormatter()
        // 2024-02-14T14:49:04.584945
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        guard let convertDate = dateFormatter.date(from: self) else { return "" }
        let replaceDateFormatter = DateFormatter()
        replaceDateFormatter.dateFormat = dateFormat // 2020-08-13 16:30
        replaceDateFormatter.locale = .current
        return replaceDateFormatter.string(from: convertDate)
    }
}
