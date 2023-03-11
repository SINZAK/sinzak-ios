//
//  MarketProducts.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import Foundation

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
