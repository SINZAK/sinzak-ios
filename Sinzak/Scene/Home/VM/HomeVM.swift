//
//  HomeVM.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Moya

protocol HomeVMInput {
    func fetchData()
    func tapProductsCell(products: Products)
    
    var selectedCategory: BehaviorRelay<[CategoryType]> { get }
    var selectedAlign: BehaviorRelay<AlignOption> { get }
    var isSaling: BehaviorRelay<Bool> { get }
    var doRefreshRelay: PublishRelay<Bool> { get }
}

protocol HomeVMOutput {
    var isLogin: Bool { get }
    
    var showSkeleton: BehaviorRelay<Bool> { get }
    var homeSectionModel: BehaviorRelay<[HomeSection]> { get }
    
    var pushProductsDetailView: PublishRelay<ProductsDetailVC> { get }
}

protocol HomeVM: HomeVMInput, HomeVMOutput {}

final class DefaultHomeVM: HomeVM {
    
    private let disposeBag = DisposeBag()
    
    init(isLogin: Bool) {
        self.isLogin = isLogin
    }
    
    // MARK: - Input
    
    func fetchData() {
        fetchSections()
    }
    
    func tapProductsCell(products: Products) {
        let vc = ProductsDetailVC()
        vc.mainView.setData(products)
        pushProductsDetailView.accept(vc)
    }
    
    // MARK: - Output
    
    var isLogin: Bool
    
    var showSkeleton: BehaviorRelay<Bool> = .init(value: false)
    var homeSectionModel: BehaviorRelay<[HomeSection]> = .init(value: [])
    
    var pushProductsDetailView: PublishRelay<ProductsDetailVC> = .init()
    
    private lazy var categories = CategoryType.allCases[1..<7]
    private lazy var categorySectionItems: [HomeSectionItem] = categories.map { HomeSectionItem.categoryItem(category: $0) }
    private lazy var categorySections: [HomeSection] = [
        .categorySection(
            title: "장르별 작품",
            items: categorySectionItems
        )
    ]
}

private extension DefaultHomeVM {
    func fetchSections() {
        showSkeleton.accept(true)

        let bannerObservable = HomeManager.shared.getBannerInfo().asObservable()
    
        if isLogin {
            let loggedInProductsObservable = HomeManager.shared.getHomeProductLoggedIn().asObservable()
            
            Observable.zip(bannerObservable, loggedInProductsObservable)
                .map({ [weak self] banners, products in
                    guard let self = self else { return }
                    
                    let productSections: [HomeSection] = zip(
                        HomeLoggedInType.allCases.map { $0.title },
                        [products.new, products.recommend, products.following]
                    )
                        .filter { !$0.1.isEmpty }
                        .map { .productSection(
                            title: $0.0,
                            items: $0.1.map { .productSectionItem(product: $0) }
                        )}
                    
                    let sectionModel: [HomeSection] = [
                        .bannerSection(items: banners.map { .bannerSectionItem(banner: $0) })
                    ] + productSections + self.categorySections
                    
                    self.homeSectionModel.accept(sectionModel)
                })
                .delay(
                    .milliseconds(500),
                    scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
                )
                .subscribe(
                    onNext: { [weak self] in
                        self?.showSkeleton.accept(false)
                    },
                    onError: { error in
                        Log.error(error)
                    })
                .disposed(by: disposeBag)
            
        } else {
            let notLoggedInProductsObservable = HomeManager.shared.getHomeProductNotLoggedIn().asObservable()
            
            Observable.zip(bannerObservable, notLoggedInProductsObservable)
                .map({ [weak self] banners, products in
                    guard let self = self else { return }
                    
                    let productSections: [HomeSection] = zip(
                        HomeNotLoggedInType.allCases.map { $0.title },
                        [products.new, products.hot, products.trading]
                    )
                        .filter { !$0.1.isEmpty }
                        .map { .productSection(
                            title: $0.0,
                            items: $0.1.map { .productSectionItem(product: $0) }
                        )}
                    
                    let sectionModel: [HomeSection] = [
                        .bannerSection(items: banners.map { .bannerSectionItem(banner: $0) })
                    ] + productSections + self.categorySections
                    
                    self.homeSectionModel.accept(sectionModel)
                })
                .delay(
                    .milliseconds(500),
                    scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
                )
                .subscribe(
                    onNext: { [weak self] in
                        self?.showSkeleton.accept(false)
                    },
                    onError: { error in
                        Log.error(error)
                    })
                .disposed(by: disposeBag)
        }
    }
}
