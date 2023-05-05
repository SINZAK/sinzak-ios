//
//  WorksVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias WorksCategorySection = SectionModel<Void, WorksCategory>

protocol WorksVMInput {
    func writeButtonTapped()
    func alignButtonTapped()
    func refresh()
    func fetchNextPage()
    func updateAlign()
    
    var selectedCategory: BehaviorRelay<[WorksCategory]> { get }
    var searchText: BehaviorRelay<String> { get }
    
    var needLoginAlert: PublishRelay<Bool> { get }
}

protocol WorksVMOutput {
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> { get }
    var pushSerachVC: PublishRelay<MarketVC> { get }
    var presentSelectAlignVC: PublishRelay<SelectAlignVC> { get }
    
    var categorySections: BehaviorRelay<[WorksCategorySection]> { get }
    var worksSections: BehaviorRelay<[MarketProductDataSection]> { get }
    
    var isSaling: BehaviorRelay<Bool> { get }
    var selectedAlign: BehaviorRelay<AlignOption> { get }
    
    var showSkeleton: BehaviorRelay<Bool> { get }
}

protocol WorksVM: WorksVMInput, WorksVMOutput {}

final class DefaultWorksVM: WorksVM {
    
    /**
     - 의뢰: true
     - 작업: false
     */
    private let isEmployment: Bool
    private let alignInfoRelay: BehaviorRelay<(isEmployment: Bool, align: AlignOption)>
    private let searchButtonTapped: BehaviorRelay<(isEmployment: Bool, text: String)>
    
    private let disposeBag = DisposeBag()
    private var currentPage: Int = 0
    
    // MARK: - Init
    
    init(
        isEmployment: Bool,
        alignInfoRelay: BehaviorRelay<(isEmployment: Bool, align: AlignOption)>,
        searchButtonTapped: BehaviorRelay<(isEmployment: Bool, text: String)>
    ) {
        self.isEmployment = isEmployment
        self.alignInfoRelay = alignInfoRelay
        self.searchButtonTapped = searchButtonTapped
        
        alignInfoRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, zip in
                let isEmployment = zip.isEmployment
                let align = zip.align
                
                guard owner.isEmployment == isEmployment else { return }
                guard owner.selectedAlign.value != align else { return }
                
                owner.selectedAlign.accept(align)
                owner.refresh()
            })
            .disposed(by: disposeBag)
        
        searchButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, zip in
                let isEmployment = zip.isEmployment
                let text = zip.text
                
                guard owner.isEmployment == isEmployment else { return }
                
                owner.searchText.accept(text)
                owner.refresh()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Input
    
    func refresh() {
        fetchWorks(
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
    
    func alignButtonTapped() {
        let vc = SelectAlignVC(with: selectedAlign, refresh)
        presentSelectAlignVC.accept(vc)
    }
    
    func fetchNextPage() {
        currentPage += 1
        WorksManager.shared.fetchWorks(
            employment: isEmployment,
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
                let current = owner.worksSections.value[0].items
                if products.isEmpty {
                    owner.currentPage -= 1
                    return
                }
                let newSection = MarketProductDataSection(items: current + products)
                owner.worksSections.accept([newSection])
            },
            onFailure: { _, error in
                Log.error(error)
            })
        .disposed(by: disposeBag)

    }
    
    func updateAlign() {
        alignInfoRelay.accept((isEmployment, selectedAlign.value))
    }
    
    var searchText: BehaviorRelay<String> = .init(value: "")
    var selectedCategory: BehaviorRelay<[WorksCategory]> = .init(value: [])
    
    var needLoginAlert: PublishRelay<Bool> = .init()
    
    // MARK: - Output
    var pushWriteCategoryVC: PublishRelay<WriteCategoryVC> = PublishRelay()
    var pushSerachVC: PublishRelay<MarketVC> = PublishRelay()
    var presentSelectAlignVC: PublishRelay<SelectAlignVC> = PublishRelay<SelectAlignVC>()
    
    var categorySections: RxRelay.BehaviorRelay<[WorksCategorySection]> = BehaviorRelay(value: [
        WorksCategorySection(
            model: Void(),
            items: WorksCategory.allCases
        )
    ])

    let worksSections: BehaviorRelay<[MarketProductDataSection]> = BehaviorRelay(value: [
        MarketProductDataSection(items: [])
    ])
    
    var isSaling: BehaviorRelay<Bool> = .init(value: false)
    var selectedAlign: BehaviorRelay<AlignOption> = .init(value: .recommend)
    
    var endRefresh: PublishRelay<Bool> = PublishRelay()
    
    var showSkeleton: BehaviorRelay<Bool> = .init(value: false)
    
}

private extension DefaultWorksVM {
    func fetchWorks(
        align: AlignOption,
        category: [WorksCategory],
        page: Int,
        size: Int,
        sale: Bool,
        search: String
    ) {
        showSkeleton.accept(true)
        WorksManager.shared.fetchWorks(
            employment: isEmployment,
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
                owner.worksSections.accept(productSection)
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
