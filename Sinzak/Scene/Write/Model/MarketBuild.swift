//
//  MarketBuild.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/27.
//

import Foundation

struct MarketBuild: Codable {
    let category: String
    let title: String
    let content: String
    let height, vertical, width: Int
    let suggest: Bool
    let price: Int
    
    init(category: CategoryType, title: String, content: String, height: Int, vertical: Int, width: Int, suggest: Bool, price: Int) {
        self.category = category.rawValue
        self.title = title
        self.content = content
        self.height = height
        self.vertical = vertical
        self.width = width
        self.suggest = suggest
        self.price = price
    }
}
struct MarketBuildEdit: Codable {
    let title: String
    let content: String
    let height, vertical, width: Int
    let suggest: Bool
    let price: Int}
