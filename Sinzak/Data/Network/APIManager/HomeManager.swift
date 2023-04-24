//
//  HomeManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Moya
import Foundation
import RxSwift

class HomeManager {
    private init () {}
    static let shared = HomeManager()
    let provider = MoyaProvider<HomeAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    
    func getHomeProductLoggedIn() -> Single<HomeLoggedInProducts> {
        return provider.rx.request(.homeLogined)
            .filterSuccessfulStatusCodes()
            .map(HomeLoggedInProductsResponse.self)
            .map { $0.data }
            .retry(2)
    }

    func getHomeProductNotLoggedIn() -> Single<HomeNotLoggedInProducts> {
        return provider.rx.request(.homeNotLogined)
            .filterSuccessfulStatusCodes()
            .map(HomeNotLoggedInProductsResponse.self)
            .map { $0.data }
            .retry(2)
    }
    
    func getBannerInfo() -> Single<[Banner]> {
        return provider.rx.request(.banner)
            .map(BannerList.self)
            .map { $0.data }
            .retry(2)
    }
}
