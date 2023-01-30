//
//  BannerModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Foundation

// 배너 목록
struct BannerList: Codable {
    let bannerList: [Banner]
    let success: Bool
}

// 배너
struct Banner: Codable {
    let id: Int
    let title, content: String
    let imageUrl: String
}

