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
}

// MARK: - RxDataSource

enum MarketSctionModel {
    case categorySection(itmes: [MarketSectionItem])
    case artSection(items: [MarketSectionItem])
}

enum MarketSectionItem {
    case categorySectionItem(title: String)
    case artSectionItem(marketProduct: MarketProduct)
}

extension MarketSctionModel: SectionModelType {
    typealias Item = MarketSectionItem
    
    var items: [MarketSectionItem] {
        switch self {
        case .categorySection(itmes: let items):
            return items.map { $0 }
        case .artSection(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: MarketSctionModel, items: [Item]) {
        switch original {
        case .categorySection(itmes: _):
            self = .categorySection(itmes: items)
        case .artSection(items: _):
            self = .artSection(items: items)
        }
    }
}
