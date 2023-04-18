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
    let provider = MoyaProvider<HomeAPI>()
    
    func getHomeProductLoggedIn() -> Single<HomeLoggedInProducts> {
        return provider.rx.request(.homeLogined)
            .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .map({ response in
                Log.debug("Thread: \(Thread.current)")
                Log.debug(response.request?.url ?? "")
                
                if !(200..<300 ~= response.statusCode) {
                    throw APIError.badStatus(code: response.statusCode)
                }
                
                do {
                    let products = try JSONDecoder().decode(HomeLoggedInProductsResponse.self, from: response.data)
                    return products.data
                } catch {
                    throw APIError.decodingError
                }
            })
    }

    func getHomeProductNotLoggedIn() -> Single<HomeNotLoggedInProducts> {
        return provider.rx.request(.homeNotLogined)
            .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .map({ response in
                Log.debug("Thread: \(Thread.current)")
                Log.debug(response.request?.url ?? "")
                
                if !(200..<300 ~= response.statusCode) {
                    throw APIError.badStatus(code: response.statusCode)
                }
                
                do {
                    let products = try JSONDecoder().decode(HomeNotLoggedInProductsResponse.self, from: response.data)
                    return products.data
                } catch {
                    throw APIError.decodingError
                }
            })
    }
    
    func getBannerInfo() -> Single<[Banner]> {
        return provider.rx.request(.banner)
            .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .map({ response in
                Log.debug(response.request?.url ?? "")
                Log.debug("Thread: \(Thread.current)")

                if !(200..<300 ~= response.statusCode) {
                    throw APIError.badStatus(code: response.statusCode)
                }
                
                do {
                    let banners = try JSONDecoder().decode(BannerList.self, from: response.data)
                    return banners.data
                } catch {
                    throw APIError.decodingError
                }
            })
    }
}
