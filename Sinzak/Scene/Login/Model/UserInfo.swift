//
//  UserInfo.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/22.
//

import Foundation

struct UserInfoResponse: Codable {
    let data: UserInfo
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case data
        case success
    }
}

// MARK: - DataClass
struct UserInfo: Codable {
    let profile: Profile
    let products: [Products]?
    let works: [Products]?
    let workEmploys: [Products]?

    enum CodingKeys: String, CodingKey {
        case profile
        case products
        case works
        case workEmploys
    }
}

// MARK: - Profile
struct Profile: Codable {
    let userID: Int
    let myProfile: Bool
    let name: String
    let introduction: String
    let portFolioURL: String
    let followingNumber: String
    let followerNumber: String
    let imageURL: String
    let univ: String
    let categoryLike: String
    let certUni: Bool
    let certAuthor: Bool
    let follow: Bool

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
}
