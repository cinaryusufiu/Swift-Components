//
//  SessionStorage.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 27.05.2024.
//

import Foundation

protocol UserStorable {
    var user: User? { get }
    mutating func saveUser(_ user: User?)
    mutating func deleteUser()
}

protocol TokenStorable {
    var token: Token? { get }
    mutating func saveToken(_ token: Token?)
    mutating func deleteToken()
}

struct SessionStorage {
    
    @UserDefaultsStorage(key: Key.user.rawValue)
    private(set) var user: User?
    
    @KeychainStorage(key: Key.token.rawValue)
    private(set) var token: Token?
    
    enum Key: String {
        case token
        case user
        
        func fullPath() -> String {
            return "\(SessionStorage.self).\(self.rawValue)"
        }
    }
}

extension SessionStorage: UserStorable {
    
    mutating func saveUser(_ user: User?) {
        self.user = user
    }
    
    mutating func deleteUser() {
        self.user = nil
    }
}

extension SessionStorage: TokenStorable {
    
    mutating func saveToken(_ token: Token?) {
        self.token = token
    }
    
    mutating func deleteToken() {
        self.token = nil
    }
}
