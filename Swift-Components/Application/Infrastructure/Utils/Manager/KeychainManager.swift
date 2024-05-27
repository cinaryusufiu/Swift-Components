//
//  KeychainManager.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 27.05.2024.
//

import Foundation
import Security

struct KeychainManagerConfig {
    let serviceIdentifier: String?
    
    init(serviceIdentifier: String?) {
        self.serviceIdentifier = serviceIdentifier
    }
}

struct KeychainManager {
    
    private static var serviceIdentifier = "com.example.app"
    
    static func configure(withConfig config: KeychainManagerConfig) {
        self.serviceIdentifier = config.serviceIdentifier ?? "com.example.app"
    }
    
    private init() { }
    
    static func save(_ data: Data, forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceIdentifier,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem {
            update(data, forKey: key)
        } else if status != errSecSuccess {
            print("Failed to save to Keychain. Status: \(status)")
        }
    }
    
    static func load(forKey key: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceIdentifier,
            kSecAttrAccount: key,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: kCFBooleanTrue as Any
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            print("Failed to load from Keychain. Status: \(status)")
            return nil
        }
        
        return data
    }
    
    static func delete(forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceIdentifier,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Failed to delete from Keychain. Status: \(status)")
        }
    }
    
    private static func update(_ data: Data, forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceIdentifier,
            kSecAttrAccount: key
        ]
        
        let attributes: [CFString: Any] = [
            kSecValueData: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status != errSecSuccess {
            print("Failed to update Keychain item. Status: \(status)")
        }
    }
}
