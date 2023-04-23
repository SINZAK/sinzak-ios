//
//  AppleToken.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/23.
//

import Foundation

struct AppleToken: Codable {
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
