//
//  Preferences.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import Foundation

#if DEBUG
private let groupIdentifier: String = "group.com.fullcar.sandbox"
#else
private let groupIdentifier: String = "group.com.fullcar"
#endif

public class UserDefaultStorage<T: Codable> {
    let uniqueKey: String
    let defaultValue: T
    
    init(uniqueKey: String, defaultValue: T) {
        self.uniqueKey = uniqueKey
        self.defaultValue = defaultValue
    }
}

@propertyWrapper
public final class ValueProperty<T>: UserDefaultStorage<T> where T: Codable {
    public var projectedValue: ValueProperty<T> { return self }
    
    private let group: UserDefaults = .init(suiteName: groupIdentifier) ?? .init()
    
    public var wrappedValue: T {
        get {
            group.value(forKey: uniqueKey) as? T ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                group.removeObject(forKey: uniqueKey)
            } else {
                group.setValue(newValue, forKey: uniqueKey)
            }
        }
    }
}

public final class Preferences {
    public static let shared: Preferences = .init()
    
    private init() { }
    
//    @ValueProperty(uniqueKey: "Preferences::nickname", defaultValue: nil)
//    public var nickname: String?
//    
//    @ValueProperty(uniqueKey: "Preferences::password", defaultValue: nil)
//    public var password: String?
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
    var isNotNil: Bool { self != nil }
}
/**
import XCTestDynamicOverlay
import ComposableArchitecture

extension Preferences: DependencyKey {
    public static var liveValue: Preferences = .shared
    public static var testValue: Preferences = unimplemented()
}

public extension DependencyValues {
    var preferences: Preferences {
        get { self[Preferences.self] }
        set { self[Preferences.self] = newValue }
    }
}
 */
