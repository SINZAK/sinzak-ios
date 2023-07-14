//
//  HomeManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Moya
import Foundation
import RxSwift

class HomeManager: ManagerType {
    private init () {}
    static let shared = HomeManager()
    let provider = MoyaProvider<HomeAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    
    func getHomeProductLoggedIn() -> Single<HomeLoggedInProducts> {
        return provider.rx.request(.homeLogined)
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<HomeLoggedInProductsDTO>.self)
            .map(filterError)
            .map(getData)
            .map { $0.toDomain() }
            .retry(2)
    }

    func getHomeProductNotLoggedIn() -> Single<HomeNotLoggedInProducts> {
        return provider.rx.request(.homeNotLogined)
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<HomeNotLoggedInProductsDTO>.self)
            .map(filterError)
            .map(getData)
            .map { $0.toDomain() }
            .retry(2)
    }
    
    func getBannerInfo() -> Single<[Banner]> {
        return provider.rx.request(.banner)
            .map(BannerList.self)
            .map { $0.data }
            .map { banners in
                return banners.isEmpty ?
                [Banner(id: -1, content: "", imageURL: "empty", href: "")] :
                banners
            }
            .retry(2)
    }
}
