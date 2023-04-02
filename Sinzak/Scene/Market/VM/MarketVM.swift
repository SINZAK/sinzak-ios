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
    func alignButtonTapped()
    func refresh()
    
    var selectedCategory: BehaviorRelay<[Category]> { get }
}

protocol MarketVMOutput {
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> { get }
    var pushSerachVC: PublishRelay<SearchVC> { get }
    var presentSelectAlignVC: PublishRelay<SelectAlignVC> { get }
    
    var categorySections: BehaviorRelay<[CategoryDataSection]> { get }
    var productSections: BehaviorRelay<[MarketProductDataSection]> { get }
    
    var isSaling: BehaviorRelay<Bool> { get }
    var currentAlign: BehaviorRelay<AlignOption> { get }
    
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
    
    func alignButtonTapped() {
        let vc = SelectAlignVC(with: currentAlign)
        presentSelectAlignVC.accept(vc)
    }
    
    var selectedCategory: BehaviorRelay<[Category]> = .init(value: [])
    
    // MARK: - Output
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> = PublishRelay()
    var pushSerachVC: PublishRelay<SearchVC> = PublishRelay()
    var presentSelectAlignVC: PublishRelay<SelectAlignVC> = PublishRelay<SelectAlignVC>()
    
    let categorySections: BehaviorRelay<[CategoryDataSection]> = BehaviorRelay(value: [
        CategoryDataSection(items: Category.allCases.map { CategoryData(category: $0) })    
    ])
    let productSections: BehaviorRelay<[MarketProductDataSection]> = BehaviorRelay(value: [
        MarketProductDataSection(items: [])
    ])
    
    var isSaling: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var currentAlign: BehaviorRelay<AlignOption> = .init(value: .recommend)
    
    var endRefresh: PublishRelay<Bool> = PublishRelay()
}

private extension DefaultMarketVM {
    func fetchMarketProducts(
        align: AlignOption,
        category: Category,
        page: Int,
        size: Int,
        sale: Bool
    ) {
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
                var currentSectionModel = self.productSections.value
                let newSectionModel: [MarketProductDataSection] = [
                    MarketProductDataSection(items: products)
                ]
                
                currentSectionModel.append(contentsOf: newSectionModel)
                self.productSections.accept(currentSectionModel)
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
                
                let newSectionModel: [MarketProductDataSection] = [
                    MarketProductDataSection(items: products)
                ]
                self.productSections.accept(newSectionModel)
            },
            onFailure: { error in
                Log.error(error)
            }
        )
        .disposed(by: disposeBag)
    }
}
