//
//  WorkBuild.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/12.
//

import Foundation

struct WorkBuild: Codable {
    let category: String
    let title: String
    let content: String
    let employment: Bool
    let price: Int
    let suggest: Bool
    
    init(category: Category, title: String, content: String, employment: Bool, price: Int, suggest: Bool) {
        self.category = category.rawValue
        self.title = title
        self.content = content
        self.employment = employment
        self.price = price
        self.suggest = suggest
    }
}

struct WorkBuildEdit: Codable {
    let title: String
    let content: String
    let price: Int
    let suggest: Bool
}
