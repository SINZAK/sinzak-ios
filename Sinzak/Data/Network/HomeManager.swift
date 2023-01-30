//
//  HomeManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Moya
import Foundation

class HomeManager {
    private init () {}
    static let shared = HomeManager()
    let provider = MoyaProvider<HomeAPI>()
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
}
