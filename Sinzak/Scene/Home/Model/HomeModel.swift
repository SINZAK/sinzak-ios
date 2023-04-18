//
//  HomeModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import Foundation

// MARK: - HomeNotLogined
struct HomeNotLoggedInProducts: Codable {
    let data: HomeNotLoggedinProductsData
    let success: Bool
}

// MARK: - Data - HomeNotLogined
struct HomeNotLoggedinProductsData: Codable {
    let trading, new, hot: [Products]
}

// MARK: - HomeLogined
struct HomeLogined: Codable {
    let data: HomeLoginedData
    let success: Bool
}

// MARK: - Data - HomeLogined
struct HomeLoginedData: Codable {
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
