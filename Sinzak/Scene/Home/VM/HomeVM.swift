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
    func viewDidLoad()
    func tapProductsCell(products: Products)
}

protocol HomeVMOutput {
    var isLogin: Bool { get }
    
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
    
    func viewDidLoad() {
        fetchSections()
    }
    
    func tapProductsCell(products: Products) {
        let vc = ProductsDetailVC()
        vc.mainView.setData(products)
        pushProductsDetailView.accept(vc)
    }
    
    // MARK: - Output
    
    var isLogin: Bool
    
    var homeSectionModel: BehaviorRelay<[HomeSection]> = .init(value: [])
    
    var pushProductsDetailView: PublishRelay<ProductsDetailVC> = .init()
    
}

private extension DefaultHomeVM {
    func fetchSections() {
        let bannerObservable = HomeManager.shared.getBannerInfo().asObservable()

        if isLogin {
            let loggedInProductsObservable = HomeManager.shared.getHomeProductLoggedIn().asObservable()
            
            Observable.zip(bannerObservable, loggedInProductsObservable)
                .subscribe(onNext: { [weak self] banners, products in
                    
                    let productSections: [HomeSection] = zip(
                        HomeLoggedInType.allCases.map { $0.title },
                        [products.recommend, products.following, products.new]
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
                }, onError: { error in
                    Log.error(error)
                })
                .disposed(by: disposeBag)
            
        } else {
            let notLoggedInProductsObservable = HomeManager.shared.getHomeProductNotLoggedIn().asObservable()
            
            Observable.zip(bannerObservable, notLoggedInProductsObservable)
                .subscribe(onNext: { [weak self] banners, products in

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
                }, onError: { error in
                    Log.error(error)
                })
                .disposed(by: disposeBag)
        }
    }
}
