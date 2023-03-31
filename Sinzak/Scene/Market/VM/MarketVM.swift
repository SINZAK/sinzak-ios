//
//  MarketVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/03/30.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol MarketVMInput {
    func writeButtonTapped()
    func searchButtonTapped()
}

protocol MarketVMOutput {
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> { get }
    var pushSerachVC: PublishRelay<SearchVC> { get }
    
    var sections: [MarketSectionModel] { get set }
}

protocol MarketVM: MarketVMInput, MarketVMOutput {}

final class DefaultMarketVM: MarketVM {
    
    // MARK: - Input
    func writeButtonTapped() {
        let vc = WriteCategoryVC()
        pushWriteCategoryVC.accept(vc)
    }
    
    func searchButtonTapped() {
        let vc = SearchVC()
        pushSerachVC.accept(vc)
    }
    
    // MARK: - Output
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> = PublishRelay()
    var pushSerachVC: PublishRelay<SearchVC> = PublishRelay()
    
    var sections: [MarketSectionModel] = [
        .categorySection(itmes: Category.allCases.map {
                MarketSectionItem.categorySectionItem(category: $0)
            }),
            .artSection(items: [
                .artSectionItem(marketProduct: MarketProduct(author: "test", complete: true, content: "tests", date: "test", id: "test", like: true, likesCnt: 50000, price: 1000, suggest: true, thumbnail: "", title: "test"))
            ])
    ]
}
    


// MARK: - RxDataSource

enum MarketSectionModel {
    case categorySection(itmes: [MarketSectionItem])
    case artSection(items: [MarketSectionItem])
}

enum MarketSectionItem {
    case categorySectionItem(category: Category)
    case artSectionItem(marketProduct: MarketProduct)
}

extension MarketSectionModel: SectionModelType {
    typealias Item = MarketSectionItem
    
    var items: [MarketSectionItem] {
        switch self {
        case .categorySection(itmes: let items):
            return items.map { $0 }
        case .artSection(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: MarketSectionModel, items: [Item]) {
        switch original {
        case .categorySection(itmes: _):
            self = .categorySection(itmes: items)
        case .artSection(items: _):
            self = .artSection(items: items)
        }
    }
}
