//
//  UserInfoDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/22.
//

import Foundation

struct UserInfoResponseDTO: Codable {
    let data: UserInfoDTO?
    let success: Bool?

    enum CodingKeys: String, CodingKey {
        case data
        case success
    }
}

// MARK: - DataClass
struct UserInfoDTO: Codable {
    let profile: ProfileDTO?
    let products: [Products]?
    let works: [Products]?
    let workEmploys: [Products]?

    enum CodingKeys: String, CodingKey {
        case profile
        case products
        case works
        case workEmploys
    }
    
    func toDomain() throws -> UserInfo {
        guard let profile = profile?.toDomain() else { throw APIError.noContent }
        return UserInfo(
            profile: profile,
            products: self.products,
            works: self.works,
            workEmploys: self.workEmploys
        )
    }
}

// MARK: - Profile
struct ProfileDTO: Codable {
    let userID: Int?
    let myProfile: Bool?
    let name: String?
    let introduction: String?
    let portFolioURL: String?
    let followingNumber: String?
    let followerNumber: String?
    let imageURL: String?
    let univ: String?
    let categoryLike: String?
    let certUni: Bool?
    let certAuthor: Bool?
    let follow: Bool?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case myProfile
        case name
        case introduction
        case portFolioURL = "portFolioUrl"
        case followingNumber
        case followerNumber
        case imageURL = "imageUrl"
        case univ
        case categoryLike
        case certUni = "cert_uni"
        case certAuthor = "cert_author"
        case follow
    }
    
    func toDomain() -> Profile {
        return Profile(
            userID: self.userID ?? 0,
            myProfile: self.myProfile ?? false,
            name: self.name ?? "",
            introduction: self.introduction,
            portFolioURL: self.portFolioURL,
            followingNumber: self.followingNumber ?? "",
            followerNumber: self.followerNumber ?? "",
            imageURL: self.imageURL,
            univ: self.univ,
            categoryLike: self.categoryLike,
            certUni: self.certUni ?? false,
            certAuthor: self.certAuthor ?? false,
            follow: self.follow ?? false
        )
    }
}
