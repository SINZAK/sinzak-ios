//
//  HomeModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import Foundation
import RxDataSources

struct HomeNotLoggedInProductsResponse: Codable {
    let data: HomeNotLoggedInProducts
    let success: Bool
}

struct HomeNotLoggedInProducts: Codable {
    let trading, new, hot: [Products]
}

struct HomeLoggedInProductsResponse: Codable {
    let data: HomeLoggedInProducts
    let success: Bool
}

struct HomeLoggedInProducts: Codable {
    let new, following, recommend: [Products]
}

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

struct MarketProductDataSection {
    var items: [Products]
}

extension MarketProductDataSection: SectionModelType {
    typealias Itemt = Products
    
    init(original: MarketProductDataSection, items: [Products]) {
        self = original
        self.items = items
    }
}
