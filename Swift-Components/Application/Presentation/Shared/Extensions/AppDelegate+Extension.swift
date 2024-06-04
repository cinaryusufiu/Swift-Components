//
//  AppDelegate+Extension.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 27.05.2024.
//

import UIKit

extension AppDelegate {
    
    func configureInfrastructure() {
       // ServiceLocator.shared.register(Router())
        KeychainManager.configure(withConfig: KeychainManagerConfig(serviceIdentifier: Bundle.main.bundleIdentifier))
        
        //Comment: -Example:
        let user = User(username: "cinaryusufiu", email: "cinaryusufiu@gmail.com")
        let token = Token(accessToken: "akskmsa324smkcmk",
                          accessTokenExpiration: "2024-12-31T23:59:59Z",
                          refreshToken: "cdklmflkdmvf87378",
                          refreshTokenExpiration: "2025-12-31T23:59:59Z")
        
        var sessionStorage = SessionStorage()
        
        sessionStorage.saveUser(user)
        sessionStorage.saveToken(token)
        
        // Kullanıcı ve token verilerini çekme
        if let savedUser = sessionStorage.user {
            print("User \(savedUser.username), \(savedUser.email)")
        }
        
        if let savedToken = sessionStorage.token {
            print("Token: \(savedToken.accessToken), \(savedToken.accessTokenExpiration)")
        }
        
        sessionStorage.deleteUser()
        sessionStorage.deleteToken()
    }
}
