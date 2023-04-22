//
//  Reissue.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/22.
//

import Foundation

struct Reissue: Codable {
    let grantType, accessToken, refreshToken: String
    let accessTokenExpireDate: Int
    let joined: Bool
    let origin: String?
}
