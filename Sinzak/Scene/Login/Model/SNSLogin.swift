//
//  SNSLogin.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/05.
//

// MARK: - SNSLoginResult
struct SNSLoginResult: Codable {
    let data: SNSLoginGrant
    let success: Bool
}

// MARK: - DataClass
struct SNSLoginGrant: Codable {
    let grantType, accessToken, refreshToken: String
    let accessTokenExpireDate: Int64
    let joined: Bool
    let origin: String
}
