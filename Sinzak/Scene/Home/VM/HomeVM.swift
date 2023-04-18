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
}

protocol HomeVMOutput {
    var isLogin: Bool { get }
    
    var homeSectionModel: BehaviorRelay<[HomeSection]> { get }
}

protocol HomeVM: HomeVMInput, HomeVMOutput {}

final class DefaultHomeVM: HomeVM {
    
    private let disposeBag = DisposeBag()
    
    init(isLogin: Bool) {
        self.isLogin = isLogin
    }
    
    // MARK: - Input
    
    func viewDidLoad() {
        
        if isLogin {
            
        } else {
            
            let bannerObservable = HomeManager.shared.getBannerInfo().asObservable()
            let productsObservable = HomeManager.shared.getHomeProductNotLoggedIn().asObservable()
            
            Observable.zip(bannerObservable, productsObservable)
                .subscribe(onNext: { [weak self] banners, products in
                    
                    let sectionModel: [HomeSection] = [
                        .bannerSection(items: banners.map { SectionItem.bannerSectionItem(banner: $0) }),
                        .productSection(title: I18NStrings.sectionNew, items: products.new.map { SectionItem.productSectionItem(product: $0) }),
                        .productSection(title: I18NStrings.sectionHot, items: products.hot.map { SectionItem.productSectionItem(product: $0) }),
                        .productSection(title: I18NStrings.sectionTrading, items: products.trading.map { SectionItem.productSectionItem(product: $0) })
                    ]
                    
                    self?.homeSectionModel.accept(sectionModel)
                }, onError: { error in
                    Log.error(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Output
    
    var isLogin: Bool
    
    var homeSectionModel: BehaviorRelay<[HomeSection]> = .init(value: [])
    
}
