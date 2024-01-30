//
//  KeyChain.swift
//  FullCar
//
//  Created by 한상진 on 12/2/23.
//  Copyright © 2023 com.fullcar. All rights reserved.
//

import Foundation
import Security

public class Keychain {
    public static let shared = Keychain()
    
    var accessGroup: String?
    var synchronizable: Bool = false
    
    private init() { }
    
    private func getPrefixedKey(key: String) -> String {
        return "com.fullcar.app.\(key)"
    }
    
    private func toString(_ value: CFString) -> String {
        return value as String
    }
    
    // MARK: Set Functions
    
    @discardableResult
    public func set(_ value: Bool, forKey key: String) -> Bool {
        let bytes: [UInt8] = value ? [1] : [0]
        let data = Data(bytes)
        
        return set(data, forKey: key)
    }
    
    @discardableResult
    public func set(_ value: String, forKey key: String) -> Bool {
        if let value = value.data(using: String.Encoding.utf8) {
            return set(value, forKey: key)
        }
        
        return false
    }
    
    @discardableResult
    public func set(_ value: Data, forKey key: String) -> Bool {
        let prefixedKey = getPrefixedKey(key: key)
        var query: [String: Any] = [
            toString(kSecClass): kSecClassGenericPassword,
            toString(kSecAttrAccount): prefixedKey,
            toString(kSecValueData): value,
            toString(kSecAttrAccessible): kSecAttrAccessibleWhenUnlocked
        ]
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: true)
        
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }
    
    // MARK: Get Functions
    public func getString(_ key: String) -> String? {
        if let data = getData(key) {
            if let currentString = String(data: data, encoding: .utf8) {
                return currentString
            }
        }
        return nil
    }
    
    public func getBool(_ key: String) -> Bool? {
        guard let data = getData(key) else { return nil }
        guard let firstBit = data.first else { return nil }
        return firstBit == 1
    }
    
    public func getData(_ key: String, asReference: Bool = false) -> Data? {
        let prefixedKey = getPrefixedKey(key: key)
        var query: [String: Any] = [
            toString(kSecClass): kSecClassGenericPassword,
            toString(kSecAttrAccount): prefixedKey,
            toString(kSecMatchLimit): kSecMatchLimitOne
        ]
        
        if asReference {
            query[toString(kSecReturnPersistentRef)] = kCFBooleanTrue
        } else {
            query[toString(kSecReturnData)] = kCFBooleanTrue
        }
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: false)
        
        var result: AnyObject?
        
        let resultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if resultCode == noErr {
            return result as? Data
        }
        return nil
    }
    
    // MARK: Delete By Key
    
    @discardableResult
    public func delete(_ key: String) -> Bool {
        let prefixedKey = getPrefixedKey(key: key)
        
        var query: [String: Any] = [
            toString(kSecClass): kSecClassGenericPassword,
            toString(kSecAttrAccount): prefixedKey
        ]
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: false)
        
        let resultCode = SecItemDelete(query as CFDictionary)
        return resultCode == noErr
    }
    
    private func addAccessGroupWhenPresent(_ items: [String: Any]) -> [String: Any] {
        guard let accessGroup = accessGroup else { return items }
        
        var result: [String: Any] = items
        result[toString(kSecAttrAccessGroup)] = accessGroup
        return result
    }
    
    private func addSynchronizableIfRequired(_ items: [String: Any], addingItems: Bool) -> [String: Any] {
        if !synchronizable { return items }
        var result: [String: Any] = items
        result[toString(kSecAttrSynchronizable)] = addingItems == true ? true : kSecAttrSynchronizableAny
        return result
    }
}

public extension String {
    static let password: String = "Keychain::password"
}

/**
import XCTestDynamicOverlay
import ComposableArchitecture

extension Keychain: DependencyKey {
    public static var liveValue: Keychain = .shared
    public static var testValue: Keychain = unimplemented()
}

public extension DependencyValues {
    var keychain: Keychain {
        get { self[Keychain.self] }
        set { self[Keychain.self] = newValue }
    }
}
 */
