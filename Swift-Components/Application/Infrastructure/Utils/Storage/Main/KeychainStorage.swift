//
//  KeychainStorage.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 27.05.2024.
//

import Foundation

@propertyWrapper
struct KeychainStorage<T: Codable> {
    private let key: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            guard let data = KeychainManager.load(forKey: key) else { return nil }
            return try? decoder.decode(T.self, from: data)
        }
        set {
            guard let value = newValue, let data = try? encoder.encode(value) else {
                KeychainManager.delete(forKey: key)
                return
            }
            KeychainManager.save(data, forKey: key)
        }
    }
}
