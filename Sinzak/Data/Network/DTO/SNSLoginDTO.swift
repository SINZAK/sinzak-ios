//
//  SNSLoginDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/03.
//

struct SNSLoginResultDTO: Codable {
    let data: SNSLoginGrantDTO?
    let success: Bool?
}

struct SNSLoginGrantDTO: Codable {
    let grantType, accessToken, refreshToken: String?
    let accessTokenExpireDate: Int64?
    let joined: Bool?
    let origin: String?
    
    func toDomain() -> SNSLoginGrant {
        SNSLoginGrant(
            grantType: grantType ?? "",
            accessToken: accessToken ?? "",
            refreshToken: refreshToken ?? "",
            accessTokenExpireDate: accessTokenExpireDate ?? 0,
            joined: joined ?? false,
            origin: origin ?? ""
        )
    }
}
