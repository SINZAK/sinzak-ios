//
//  Category.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/27.
//

import Foundation
import RxDataSources
import UIKit

enum ProductsCategory: String, CaseIterable {
    case all
    case painting
    case orient
    case sculpture
    case print
    case craft
    case other
    
    var text: String {
        switch self {
        case .all:              return "전체"
        case .painting:         return "회화일반"
        case .orient:           return "동양화"
        case .sculpture:        return "조소"
        case .print:            return "판화"
        case .craft:            return "공예"
        case .other:            return "기타"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .painting:         return UIImage(named: "category-painting")
        case .orient:           return UIImage(named: "category-orient")
        case .sculpture:        return UIImage(named: "category-sculpture")
        case .print:            return UIImage(named: "category-print")
        case .craft:            return UIImage(named: "category-craft")
        case .other:            return UIImage(named: "category-other")
        default:                return UIImage()
        }
        
    }
}

struct Category {
    let type: ProductsCategory
    var text: String {
        return type.text
    }
    var needSelect: Bool
}

struct CategoryData {
    let category: Category
}

struct CategoryDataSection {
    var items: [CategoryData]
}

extension CategoryDataSection: SectionModelType {
    typealias Item = CategoryData
    
    init(original: CategoryDataSection, items: [CategoryData]) {
        self = original
        self.items = items
    }
}
