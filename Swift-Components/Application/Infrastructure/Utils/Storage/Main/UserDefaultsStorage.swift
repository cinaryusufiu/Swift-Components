//
//  UserDefaultsStorage.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 27.05.2024.
//

import Foundation

@propertyWrapper
struct UserDefaultsStorage<T: Codable> {
    private let key: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            if let data = UserDefaults.standard.data(forKey: key) {
                return try? decoder.decode(T.self, from: data)
            }
            return nil
        }
        set {
            guard let value = newValue else { 
                UserDefaults.standard.removeObject(forKey: key)
                return }
            
            if let encoded = try? encoder.encode(value) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}
