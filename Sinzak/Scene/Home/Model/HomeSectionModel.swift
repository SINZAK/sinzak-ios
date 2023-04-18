//
//  HomeSectionModel.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/18.
//

import RxDataSources

enum HomeSection {
    case bannerSection(items: [SectionItem])
    case productSection(title: String, items: [SectionItem])

}

enum SectionItem {
    case bannerSectionItem(banner: Banner)
    case productSectionItem(product: Products)
}

extension HomeSection: SectionModelType {
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .bannerSection(items: let items):
            return items
        case .productSection(title: _, items: let items):
            return items
        }
    }
    
    init(original: HomeSection, items: [SectionItem]) {
        switch original {
        case .bannerSection(items: _):
            self = .bannerSection(items: items)
        case let .productSection(title: title, items: _):
            self = .productSection(title: title, items: items)
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
        }
    }
}

