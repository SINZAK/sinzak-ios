//
//  MyPostListVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol MyPostListVMInput {
    func fetchScrapList()
}

protocol MyPostListVMOutput {
    var productSections: BehaviorRelay<[MarketProductDataSection]> { get }
    
    var isShowSkeleton: PublishRelay<Bool> { get }
}

protocol MyPostListVM: ScrapListVMInput, ScrapListVMOutput {}

final class DefaultMyPostListVM: ScrapListVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func fetchScrapList() {
        isShowSkeleton.accept(true)
        UserQueryManager.shared.fetchScrapList()
            .map { return [MarketProductDataSection(items: $0)] }
            .delay(
                .milliseconds(500),
                scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
            )
            .subscribe(
                with: self,
                onSuccess: { owner, productsSection in
                    owner.productSections.accept(productsSection)
                },
                onFailure: { _, error in
                    Log.error(error)
                },
                onDisposed: { owner in
                    owner.isShowSkeleton.accept(false)
                })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    
    var productSections: RxRelay.BehaviorRelay<[MarketProductDataSection]> = .init(value: [])
    
    var isShowSkeleton: PublishRelay<Bool> = .init()
}
