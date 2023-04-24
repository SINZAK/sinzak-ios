//
//  HomeSectionModel.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/18.
//

import RxDataSources

enum HomeSection {
    case bannerSection(items: [HomeSectionItem])
    case productSection(title: String, items: [HomeSectionItem])
    case categorySection(title: String, items: [HomeSectionItem])
}

enum HomeSectionItem {
    case bannerSectionItem(banner: Banner)
    case productSectionItem(product: Products)
    case categoryItem(category: Category)
}

extension HomeSection: SectionModelType {
    
    typealias Item = HomeSectionItem
    
    var items: [HomeSectionItem] {
        switch self {
        case .bannerSection(items: let items):
            return items
        case .productSection(title: _, items: let items):
            return items
        case .categorySection(title: _, items: let items):
            return items
        }
    }
    
    init(original: HomeSection, items: [HomeSectionItem]) {
        switch original {
        case .bannerSection(items: _):
            self = .bannerSection(items: items)
        case let .productSection(title: title, items: _):
            self = .productSection(title: title, items: items)
        case let .categorySection(title: title, items: _):
            self = .categorySection(title: title, items: items)
        }
    }
}

extension HomeSection {
    var title: String? {
        switch self {
        case .bannerSection(items: _):
            return nil
        case let .productSection(title: title, items: _):
            return title
        case let.categorySection(title: title, items: _):
            return title
        }
    }
}

