//
//  ProductManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import Foundation
import Moya

class ProductsManager {
    private init () {}
    static let shared = ProductsManager()
    let provider = MoyaProvider<ProductsAPI>()
    /// 전체 조회
    func viewAllProducts() {
        provider.request(.products(align: "recommend", page: 3, size: 3, category: "painting", sale: true)) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MarketProducts.self, from: data.data)
                    print("마켓조회🔥", result)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
