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
    
//    var endRefresh: PublishRelay<Bool> { get }
    
    var presentSkeleton: PublishRelay<MarketSkeletonVC> { get }
}

protocol MarketVM: MarketVMInput, MarketVMOutput {}

final class DefaultMarketVM: MarketVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func viewDidLoad() {
        fetchMarketProducts(
            align: currentAlign.value,
            category: selectedCategory.value,
            page: 0,
            size: 15,
            sale: isSaling.value
        )
    }
    
    func refresh() {
        fetchMarketProducts(
            align: currentAlign.value,
            category: selectedCategory.value,
            page: 0,
            size: 15,
            sale: isSaling.value
        )
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
    
    var presentSkeleton: PublishRelay<MarketSkeletonVC> = .init()
}

private extension DefaultMarketVM {
    func fetchMarketProducts(
        align: AlignOption,
        category: [Category],
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
        .map { return [MarketProductDataSection(items: $0)] }
        .subscribe(on: SerialDispatchQueueScheduler(
            queue: .global(),
            internalSerialQueueName: "productSection")
        )
        .subscribe(with: self, onSuccess: { owner, productSection in
            owner.productSections.accept(productSection)
        }, onFailure: { _, error in
            Log.error(error)
        })
        .disposed(by: disposeBag)
    }
}
