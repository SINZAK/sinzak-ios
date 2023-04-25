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
    
    var selectedCategory: BehaviorRelay<[CategoryType]> { get }
    
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
}

protocol MarketVM: MarketVMInput, MarketVMOutput {}

final class DefaultMarketVM: MarketVM {
    
    private let disposeBag = DisposeBag()
    
    var doRefreshRelay: PublishRelay<Bool>
        
    // MARK: - Init
    
    init(
        _ selectedCategory: BehaviorRelay<[CategoryType]>,
        _ selectedAlign: BehaviorRelay<AlignOption>,
        _ isSaling: BehaviorRelay<Bool>,
        _ doRefreshRelay: PublishRelay<Bool>
    ) {
        self.selectedCategory = selectedCategory
        self.selectedAlign = selectedAlign
        self.isSaling = isSaling
        self.doRefreshRelay = doRefreshRelay
    
        doRefreshRelay
            .subscribe(with: self, onNext: { owner, _ in
                owner.refresh()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Input
    
    func viewDidLoad() {
        fetchMarketProducts(
            align: selectedAlign.value,
            category: selectedCategory.value,
            page: 0,
            size: 15,
            sale: isSaling.value
        )
    }
    
    func refresh() {
        fetchMarketProducts(
            align: selectedAlign.value,
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
        let vc = SelectAlignVC(with: selectedAlign, doRefreshRelay)
        presentSelectAlignVC.accept(vc)
    }
    
    var selectedCategory: BehaviorRelay<[CategoryType]>
    
    var needLoginAlert: PublishRelay<Bool> = .init()
    
    // MARK: - Output
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> = PublishRelay()
    var pushSerachVC: PublishRelay<SearchVC> = PublishRelay()
    var presentSelectAlignVC: PublishRelay<SelectAlignVC> = PublishRelay<SelectAlignVC>()
    
    let categorySections: BehaviorRelay<[CategoryDataSection]> = BehaviorRelay(value: [
        CategoryDataSection(items: CategoryType.allCases.map {
            let category = $0 == .all ?
            Category(type: $0, isSelected: true) :
            Category(type: $0, isSelected: false)
            
            return CategoryData(category: category)
        })
    ])
    let productSections: BehaviorRelay<[MarketProductDataSection]> = BehaviorRelay(value: [
        MarketProductDataSection(items: [])
    ])
    
    var isSaling: BehaviorRelay<Bool>
    var selectedAlign: BehaviorRelay<AlignOption>
    
    var endRefresh: PublishRelay<Bool> = PublishRelay()
    
    var showSkeleton: BehaviorRelay<Bool> = .init(value: false)
}

private extension DefaultMarketVM {
    func fetchMarketProducts(
        align: AlignOption,
        category: [CategoryType],
        page: Int,
        size: Int,
        sale: Bool
    ) {
        showSkeleton.accept(true)
        ProductsManager.shared.fetchProducts(
            align: align,
            category: category,
            page: page,
            size: size,
            sale: sale
        )
        .map { return [MarketProductDataSection(items: $0)] }
        .delay(
            .milliseconds(500),
            scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
        )
        .subscribe(on: SerialDispatchQueueScheduler(
            queue: .global(),
            internalSerialQueueName: "productSection")
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
