//
//  JHRequest.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

public typealias Parameters = [String: Any]

@frozen public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
