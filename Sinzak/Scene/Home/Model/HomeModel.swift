//
//  HomeModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import Foundation

// MARK: - HomeNotLogined
struct HomeNotLoggedInProductsResponse: Codable {
    let data: HomeNotLoggedInProducts
    let success: Bool
}

// MARK: - Data - HomeNotLogined
struct HomeNotLoggedInProducts: Codable {
    let trading, new, hot: [Products]
}

// MARK: - HomeLogined
struct HomeLoggedInProductsResponse: Codable {
    let data: HomeLoggedInProducts
    let success: Bool
}

// MARK: - Data - HomeLogined
struct HomeLoggedInProducts: Codable {
    let new, following, recommend: [Products]
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
