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
    
    var bannerIndex: BehaviorRelay<Int> { get }
    
    var selectedCategory: BehaviorRelay<[CategoryType]> { get }
    var selectedAlign: BehaviorRelay<AlignOption> { get }
    var isSaling: BehaviorRelay<Bool> { get }
    var needRefresh: BehaviorRelay<Bool> { get }
    
    var needLoginAlert: PublishRelay<Bool> { get }
}

protocol HomeVMOutput {
    var isLogin: Bool { get }
    
    var showSkeleton: BehaviorRelay<Bool> { get }
    var homeSectionModel: BehaviorRelay<[HomeSection]> { get }
    
    var bannerTotalIndex: BehaviorRelay<Int> { get }
    
    var pushProductsDetailView: PublishRelay<ProductsDetailVC> { get }
    
    var moreCell: [(AlignOption, Int)] { get }
}

protocol HomeVM: HomeVMInput, HomeVMOutput {}

final class DefaultHomeVM: HomeVM {
    
    private let disposeBag = DisposeBag()
    
    let needRefresh: BehaviorRelay<Bool>
    
    init(
        _ selectedCategory: BehaviorRelay<[CategoryType]>,
        _ selectedAlign: BehaviorRelay<AlignOption>,
        _ isSaling: BehaviorRelay<Bool>,
        _ needRefresh: BehaviorRelay<Bool>
    ) {
        self.isLogin = UserInfoManager.isLoggedIn
        self.selectedCategory = selectedCategory
        self.selectedAlign = selectedAlign
        self.isSaling = isSaling
        self.needRefresh = needRefresh
    }
    
    // MARK: - Input
    
    func fetchData() {
        fetchSections()
    }
    
    func tapProductsCell(products: Products) {
        let vm = DefaultProductsDetailVM(refresh: fetchData)
        let vc = ProductsDetailVC(id: products.id, type: .purchase, viewModel: vm)
//        vc.mainView.setData(products)
        pushProductsDetailView.accept(vc)
    }
    
    var bannerIndex: BehaviorRelay<Int> = .init(value: 0)
    
    var selectedCategory: BehaviorRelay<[CategoryType]>
    var selectedAlign: BehaviorRelay<AlignOption>
    var isSaling: BehaviorRelay<Bool>
    
    var bannerTotalIndex: BehaviorRelay<Int> = .init(value: 3)
    
    var needLoginAlert: PublishRelay<Bool> = .init()
    
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
    
    var moreCell: [(AlignOption, Int)] = []
}

private extension DefaultHomeVM {
    func fetchSections() {
        showSkeleton.accept(true)

        let bannerObservable = HomeManager.shared.getBannerInfo().asObservable()
        moreCell = []
    
        if isLogin {
            let loggedInProductsObservable = HomeManager.shared.getHomeProductLoggedIn().asObservable()
            
            Observable.zip(bannerObservable, loggedInProductsObservable)
                .map({ [weak self] banners, products in
                    guard let self = self else { return }
                    
                    self.bannerTotalIndex.accept(banners.count)
                    
                    let productSections: [HomeSection] = zip(
                        [HomeLoggedInType.new.title, HomeLoggedInType.recommend.title, HomeLoggedInType.following.title ],
                        [(products.new, AlignOption.recent), (products.recommend, AlignOption.recommend), (products.following, AlignOption.popular)]
                    )
                        .filter { !$0.1.0.isEmpty }
                        .map {
                            let moreCell = Products(
                                id: -1, title: "",
                                content: "", author: "",
                                price: 0, thumbnail: "moreCell",
                                date: "", suggest: false,
                                likesCnt: 0, complete: false,
                                popularity: 0, like: false
                            )
                            let items: [HomeSectionItem] = ($0.1.0 + [moreCell]).map { .productSectionItem(product: $0) }
                            self.moreCell.append(($0.1.1, items.count))
                            
                            return .productSection(
                                title: $0.0,
                                items: items
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
                    
                    self.bannerTotalIndex.accept(banners.count)
                    
                    let productSections: [HomeSection] = zip(
                        [HomeNotLoggedInType.new.title, HomeNotLoggedInType.hot.title, HomeNotLoggedInType.trading.title],
                        [(products.new, AlignOption.recent), (products.hot, AlignOption.popular), (products.trading, AlignOption.high)]
                    )
                    .filter { !$0.1.0.isEmpty }
                    .map {
                        let moreCell = Products(
                            id: -1, title: "",
                            content: "", author: "",
                            price: 0, thumbnail: "moreCell",
                            date: "", suggest: false,
                            likesCnt: 0, complete: false,
                            popularity: 0, like: false
                        )
                        let items: [HomeSectionItem] = ($0.1.0 + [moreCell]).map { .productSectionItem(product: $0) }
                        self.moreCell.append(($0.1.1, items.count))
                        
                        return .productSection(
                            title: $0.0,
                            items: items
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
