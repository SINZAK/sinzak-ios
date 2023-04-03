//
//  MarketProducts.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import Foundation
import Differentiator

struct MarketProduct: Codable {
    let id: Int
    let title, content, author: String
    let price: Int
    let thumbnail: String
    let date: String
    let suggest, like: Bool
    let likesCnt: Int
    let complete: Bool
    let popularity: Int
}

struct MarketProductDataSection {
    var items: [MarketProduct]
}

extension MarketProductDataSection: SectionModelType {
    typealias Itemt = MarketProduct
    
    init(original: MarketProductDataSection, items: [MarketProduct]) {
        self = original
        self.items = items
    }
}
