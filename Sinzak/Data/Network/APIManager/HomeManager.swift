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
    
    func getHomeProductNotLogined(completion: @escaping (Result<HomeNotLoggedInProducts, Error>) -> Void) {
        provider.request(.homeNotLogined) { result in
            switch result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(HomeNotLoggedInProducts.self, from: data.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getBannerInfo(completion: @escaping (Result<BannerList, Error>) -> Void) {
        provider.request(.banner) { result in
            switch result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(BannerList.self, from: data.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getHomeProductNotLoggedIn() -> Single<HomeNotLoggedinProductsData> {
        return provider.rx.request(.homeNotLogined)
            .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .map({ response in
                
                Log.debug(response.request?.url ?? "")
                
                if !(200..<300 ~= response.statusCode) {
                    throw APIError.badStatus(code: response.statusCode)
                }
                
                do {
                    let products = try JSONDecoder().decode(HomeNotLoggedInProducts.self, from: response.data)
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
