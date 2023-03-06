//
//  HomeViewModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Foundation
import RxSwift
import Moya
import RxMoya

class HomeViewModel {
    let homeObservable: Single<HomeNotLogined>
    let bannerObservable: Single<BannerList>
    
    init(provider: MoyaProvider<HomeAPI>) {
        homeObservable = provider.rx.request(.homeNotLogined)
            .map { response -> HomeNotLogined in
                guard let home = try? JSONDecoder().decode(HomeNotLogined.self, from: response.data) else {
                    throw APIError.decodingFailed
                }
                print("🍺🍺🍺 Home", home)
                return home
            }
        bannerObservable = provider.rx.request(.banner)
            .map { response -> BannerList in
                guard let banner = try? JSONDecoder().decode(BannerList.self, from: response.data) else {
                    throw APIError.decodingFailed
                }
                print("🍺🍺🍺🍺 Banner", banner)
                return banner
            }

    }
}
