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
    func viewDidLoad()
    func writeButtonTapped()
    func searchButtonTapped()
    func refresh()
}

protocol MarketVMOutput {
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> { get }
    var pushSerachVC: PublishRelay<SearchVC> { get }
    var sections: BehaviorRelay<[MarketSectionModel]> { get }
    var isSaling: BehaviorRelay<Bool> { get }
    var endRefresh: PublishRelay<Bool> { get }
}

protocol MarketVM: MarketVMInput, MarketVMOutput {}

final class DefaultMarketVM: MarketVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func viewDidLoad() {
        fetchMarketProducts(
            align: .recommend,
            category: .all,
            page: 0,
            size: 15,
            sale: false
        )
    }
    
    func refresh() {
        endRefresh.accept(false)
        refreshMarketProducts(
            align: .recommend,
            category: .all,
            page: 0,
            size: 15,
            sale: isSaling.value
        )
        endRefresh.accept(true)
    }
    
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
    var sections: BehaviorRelay<[MarketSectionModel]> = BehaviorRelay(value: [
        .categorySection(itmes: Category.allCases.map {
            .categorySectionItem(category: $0)
        })
    ])
    var isSaling: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var endRefresh: PublishRelay<Bool> = PublishRelay()
}

private extension DefaultMarketVM {
    func fetchMarketProducts(align: AlignOption, category: Category, page: Int, size: Int, sale: Bool) {
        ProductsManager.shared.fetchProducts(
            align: align,
            category: category,
            page: page,
            size: size,
            sale: sale
        )
        .subscribe(
            onSuccess: { [weak self] products in
                guard let self = self else { return }
                var currentSectionModel = self.sections.value
                let newSectionModel: [MarketSectionModel] = [
                    .artSection(items: products.map {
                        .artSectionItem(marketProduct: $0)
                    })
                ]
                currentSectionModel.append(contentsOf: newSectionModel)
                self.sections.accept(currentSectionModel)
            },
            onFailure: { error in
                Log.error(error)
            }
        )
        .disposed(by: disposeBag)
    }
    
    func refreshMarketProducts(align: AlignOption, category: Category, page: Int, size: Int, sale: Bool) {
        ProductsManager.shared.fetchProducts(
            align: align,
            category: category,
            page: page,
            size: size,
            sale: sale
        )
        .subscribe(
            onSuccess: { [weak self] products in
                guard let self = self else { return }
                
                
                let newSectionModel: [MarketSectionModel] = [
                    .categorySection(itmes: Category.allCases.map {
                        .categorySectionItem(category: $0)
                    }),
                    .artSection(items: products.map {
                        .artSectionItem(marketProduct: $0)
                    })
                ]
                self.sections.accept(newSectionModel)
            },
            onFailure: { error in
                Log.error(error)
            }
        )
        .disposed(by: disposeBag)
    }
}

// MARK: - RxDataSource

enum MarketSectionModel: Equatable {
    static func == (lhs: MarketSectionModel, rhs: MarketSectionModel) -> Bool {
        type(of: lhs) == type(of: lhs)
    }
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
