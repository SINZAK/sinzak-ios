//
//  MarketProducts.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import Foundation
import Differentiator

// MARK: - ProductList
struct MarketProducts: Codable {
    let content: [MarketProduct]
    let pageable: Pageable
    let empty, first, last: Bool
    let number, numberOfElements: Int
    let size: Int
    let sort: Sort
    let totalElements, totalPages: Int
}

// MARK: - Content
struct MarketProduct: Codable {
    let author: String
    let complete: Bool
    let content, date, id: String
    let like: Bool
    let likesCnt, price: Int
    let suggest: Bool
    let thumbnail: String
    let title: String
}

struct SectionOfMarketProduct {
    var header: MarketHeader
    var items: [MarketProductItem]
}

extension SectionOfMarketProduct: SectionModelType {
    typealias MarketProductItem = MarketProduct
    
    init(original: SectionOfMarketProduct, items: [MarketProduct]) {
        self = original
        self.items = items
    }
}

// MARK: - Pageable
struct Pageable: Codable {
    let offset, pageNumber, pageSize: Int
    let paged: Bool
    let sort: Sort
    let unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}
