//
//  HomeModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import Foundation

// MARK: - HomeNotLogined
struct HomeNotLogined: Codable {
    let data: DataClass
    let success: Bool
}

// MARK: - DataClass
struct DataClass: Codable {
    let trading, new, hot: [Products]
}

// MARK: - Hot
struct Products: Codable {
    let id: Int
    let title, content, author: String
    let price: Int
    let thumbnail: String?
    let date: String
    let suggest: Bool
    let likesCnt: Int
    let complete: Bool
    let popularity: Int
    let like: Bool
}
