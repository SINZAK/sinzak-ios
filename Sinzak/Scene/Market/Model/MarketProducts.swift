//
//  MarketProducts.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import Foundation
import Differentiator

/*
struct MarketProducts: Codable {
    let content: [MarketProduct]
    let pageable: Pageable
    let last: Bool
    let totalElements, totalPages: Int
    let sort: Sort
    let first: Bool
    let size, number, numberOfElements: Int
    let empty: Bool
}

// MARK: - MarketProduct
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

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}
 */


// MARK: - Welcome
struct MarketProducts: Codable {
    let content: [MarketProduct]
    let pageable: Pageable
    let last: Bool
    let totalElements, totalPages: Int
    let sort: Sort
    let first: Bool
    let size, number, numberOfElements: Int
    let empty: Bool
}

// MARK: - Content
struct MarketProduct: Codable {
    let id: Int
    let title, content, author: String
    let price: Int
    let thumbnail: String?
    let date: String
    let suggest, like: Bool
    let likesCnt: Int
    let complete: Bool
    let popularity: Int
}

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}
