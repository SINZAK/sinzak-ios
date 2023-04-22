//
//  ReissueDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/22.
//

import Foundation

struct ReissueDTO: Codable {
    let grantType: String?
    let accessToken: String?
    let refreshToken: String?
    let accessTokenExpireDate: Int?
    let joined: Bool?
    let origin: String?
    
    func toDomain() -> Reissue {
        Reissue(
            grantType: self.grantType ?? "",
            accessToken: self.accessToken ?? "",
            refreshToken: self.refreshToken ?? "",
            accessTokenExpireDate: self.accessTokenExpireDate ?? 0,
            joined: self.joined ?? false,
            origin: self.origin
        )
    }
}
