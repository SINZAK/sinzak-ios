//
//  BannerModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Foundation

struct BannerList: Codable {
    let data: [Banner]
    let success: Bool
}

// MARK: - Datum
struct Banner: Codable {
    let id: Int
    let content: String
    let imageURL: String
    let href: String

    enum CodingKeys: String, CodingKey {
        case id, content
        case imageURL = "imageUrl"
        case href
    }
}
