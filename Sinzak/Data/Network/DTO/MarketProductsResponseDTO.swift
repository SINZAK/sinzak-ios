//
//  MarketProductsResponseDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/03/31.
//

import Foundation

struct MarketProductsResponseDTO: Codable {
    let content: [MarketProductResponseDTO]?
    let pageable: Pageable?
    let last: Bool?
    let totalElements, totalPages: Int?
    let sort: Sort?
    let first: Bool?
    let size, number, numberOfElements: Int?
    let empty: Bool?
}

struct MarketProductResponseDTO: Codable {
    let id: Int?
    let title, content, author: String?
    let price: Int?
    let thumbnail: String?
    let date: String?
    let suggest, like: Bool?
    let likesCnt: Int?
    let complete: Bool?
    let popularity: Int?
}

struct Pageable: Codable {
    let sort: Sort?
    let offset, pageNumber, pageSize: Int?
    let paged, unpaged: Bool?
}

struct Sort: Codable {
    let empty, sorted, unsorted: Bool?
}

extension MarketProductResponseDTO {
    func toDomain() -> Products {
        Products(
            id: id ?? 0,
            title: title ?? "",
            content: content ?? "",
            author: author ?? "",
            price: price ?? 0,
            thumbnail: thumbnail,
            date: date ?? "",
            suggest: suggest ?? false,
            likesCnt: likesCnt ?? 0,
            complete: complete ?? false,
            popularity: popularity ?? 0,
            like: like ?? false
        )
    }
}
