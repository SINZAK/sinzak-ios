//
//  Products.swift
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
    let title: String
    let content: String
    let author: String
    let price: Int
    let thumbnail: String?
    let date: String
    let suggest: Bool
    let likesCnt: Int
    let complete: Bool
    let popularity: Int
    let like: Bool
    
    init(id: Int, title: String, content: String, author: String, price: Int, thumbnail: String, date: String, suggest: Bool, likesCnt: Int, complete: Bool, popularity: Int, like: Bool) {
        self.id = id
        self.title = title
        self.content = content
        self.author = author
        self.price = price
        self.thumbnail = thumbnail
        self.date = date
        self.suggest = suggest
        self.likesCnt = likesCnt
        self.complete = complete
        self.popularity = popularity
        self.like = like
    }
    
    init(with productResponse: MarketProductResponseDTO) {
        self.id = productResponse.id ?? -404
        self.title = productResponse.title ?? ""
        self.content = productResponse.content ?? ""
        self.author = productResponse.author ?? ""
        self.price = productResponse.price ?? 0
        self.thumbnail = productResponse.thumbnail ?? ""
        self.date = productResponse.date ?? ""
        self.suggest = productResponse.suggest ?? false
        self.likesCnt = productResponse.likesCnt ?? 0
        self.complete = productResponse.complete ?? false
        self.popularity = productResponse.popularity ?? 0
        self.like = productResponse.like ?? false
    }
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
