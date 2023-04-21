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
}

protocol HomeVMOutput {
    var isLogin: Bool { get }
    
    var showSkeleton: BehaviorRelay<Bool> { get }
    var homeSectionModel: BehaviorRelay<[HomeSection]> { get }
    
    var pushProductsDetailView: PublishRelay<ProductsDetailVC> { get }
}

protocol HomeVM: HomeVMInput, HomeVMOutput {}

final class DefaultHomeVM: HomeVM {
    
    private let provider = MoyaProvider<HomeAPI>()
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
}

private extension DefaultHomeVM {
    func fetchSections() {
        showSkeleton.accept(true)

        let bannerObservable = provider.rx.request(.banner, callbackQueue: .global())
            .do(onSuccess: {
                Log.debug($0.request?.url ?? "")
            })
            .filterSuccessfulStatusCodes()
            .map(BannerList.self)
            .map { $0.data }
            .asObservable()
                
        if isLogin {
            let loggedInProductsObservable = HomeManager.shared.getHomeProductLoggedIn().asObservable()
            
            Observable.zip(bannerObservable, loggedInProductsObservable)
                .map({ [weak self] banners, products in
                    
                    // TODO: ~~~님을 위한 맞춤 거래 추가해야함
                    let productSections: [HomeSection] = zip(
                        HomeLoggedInType.allCases.map { $0.title },
                        [products.recommend, products.new, products.following]
                    )
                        .filter { !$0.1.isEmpty }
                        .map { .productSection(
                            title: $0.0,
                            items: $0.1.map { .productSectionItem(product: $0) }
                        )}
                    
                    let sectionModel: [HomeSection] = [
                        .bannerSection(items: banners.map { .bannerSectionItem(banner: $0) })
                    ] + productSections
                    
                    self?.homeSectionModel.accept(sectionModel)
                })
                .delay(
                    .milliseconds(1000),
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
                    ] + productSections
                    
                    self?.homeSectionModel.accept(sectionModel)
                })
                .delay(
                    .milliseconds(1000),
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
