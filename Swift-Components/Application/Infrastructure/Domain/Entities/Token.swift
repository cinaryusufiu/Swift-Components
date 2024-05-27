//
//  Token.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 27.05.2024.
//

import Foundation

struct Token: Codable {
    let accessToken: String
    let accessTokenExpiration: String
    let refreshToken: String
    let refreshTokenExpiration: String
}
