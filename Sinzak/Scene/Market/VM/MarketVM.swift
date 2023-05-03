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
    func alignButtonTapped()
    func refresh()
    func fetchNextPage()
    
    var selectedCategory: BehaviorRelay<[CategoryType]> { get }
    var searchText: BehaviorRelay<String> { get }
    
    var needLoginAlert: PublishRelay<Bool> { get }
}

protocol MarketVMOutput {
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> { get }
    var pushSerachVC: PublishRelay<SearchVC> { get }
    var presentSelectAlignVC: PublishRelay<SelectAlignVC> { get }
    
    var categorySections: BehaviorRelay<[CategoryDataSection]> { get }
    var productSections: BehaviorRelay<[MarketProductDataSection]> { get }
    
    var isSaling: BehaviorRelay<Bool> { get }
    var selectedAlign: BehaviorRelay<AlignOption> { get }
    
    var showSkeleton: BehaviorRelay<Bool> { get }
    var needRefresh: BehaviorRelay<Bool> { get }
}

protocol MarketVM: MarketVMInput, MarketVMOutput {}

final class DefaultMarketVM: MarketVM {
    
    private let disposeBag = DisposeBag()
    private var currentPage: Int = 0
    
    // MARK: - Init
    
    init(
        _ selectedCategory: BehaviorRelay<[CategoryType]>,
        _ selectedAlign: BehaviorRelay<AlignOption>,
        _ isSaling: BehaviorRelay<Bool>,
        _ needRefresh: BehaviorRelay<Bool>
    ) {
        self.selectedCategory = selectedCategory
        self.selectedAlign = selectedAlign
        self.isSaling = isSaling
        self.needRefresh = needRefresh
    }
    
    // MARK: - Input
    
    func refresh() {
        fetchMarketProducts(
            align: selectedAlign.value,
            category: selectedCategory.value,
            page: 0,
            size: 15,
            sale: isSaling.value,
            search: searchText.value
        )
        currentPage = 0
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
        let vc = SelectAlignVC(with: selectedAlign, refresh)
        presentSelectAlignVC.accept(vc)
    }
    
    func fetchNextPage() {
        currentPage += 1
        ProductsManager.shared.fetchProducts(
            align: selectedAlign.value,
            category: selectedCategory.value,
            page: currentPage,
            size: 15,
            sale: isSaling.value,
            search: searchText.value
        )
        .subscribe(
            with: self,
            onSuccess: { owner, products in
                let current = owner.productSections.value[0].items
                if products.isEmpty {
                    owner.currentPage -= 1
                    return
                }
                let newSection = MarketProductDataSection(items: current + products)
                owner.productSections.accept([newSection])
            },
            onFailure: { _, error in
                Log.error(error)
            })
        .disposed(by: disposeBag)

    }
    
    var searchText: BehaviorRelay<String> = .init(value: "")
    var selectedCategory: BehaviorRelay<[CategoryType]>
    
    var needLoginAlert: PublishRelay<Bool> = .init()
    
    // MARK: - Output
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> = PublishRelay()
    var pushSerachVC: PublishRelay<SearchVC> = PublishRelay()
    var presentSelectAlignVC: PublishRelay<SelectAlignVC> = PublishRelay<SelectAlignVC>()
    
    lazy var categorySections: BehaviorRelay<[CategoryDataSection]> = BehaviorRelay(value: [
        CategoryDataSection(items: CategoryType.allCases
            .map {
                let selected = selectedCategory.value
                let needSelect: CategoryType = selected.isEmpty ? .all : selected[0]
                
                let category = $0 == needSelect ?
                Category(type: $0, needSelect: true) :
                Category(type: $0, needSelect: false)
                
                return CategoryData(category: category)
            })
    ])
    let productSections: BehaviorRelay<[MarketProductDataSection]> = BehaviorRelay(value: [
        MarketProductDataSection(items: [])
    ])
    
    var isSaling: BehaviorRelay<Bool>
    var selectedAlign: BehaviorRelay<AlignOption>
    var needRefresh: BehaviorRelay<Bool>
    
    var endRefresh: PublishRelay<Bool> = PublishRelay()
    
    var showSkeleton: BehaviorRelay<Bool> = .init(value: false)
    
}

private extension DefaultMarketVM {
    func fetchMarketProducts(
        align: AlignOption,
        category: [CategoryType],
        page: Int,
        size: Int,
        sale: Bool,
        search: String
    ) {
        showSkeleton.accept(true)
        ProductsManager.shared.fetchProducts(
            align: align,
            category: category,
            page: page,
            size: size,
            sale: sale,
            search: search
        )
        .map { return [MarketProductDataSection(items: $0)] }
        .delay(
            .milliseconds(500),
            scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
        )
        .subscribe(
            with: self,
            onSuccess: { owner, productSection in
                owner.productSections.accept(productSection)
            },
            onFailure: { _, error in
                Log.error(error)
            },
            onDisposed: { owner in
                owner.showSkeleton.accept(false)
            })
        .disposed(by: disposeBag)
    }
}
