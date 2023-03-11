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
    func viewAllProducts(align: AlignOption, category: Category, page: Int, size: Int, sale: Bool, completion: @escaping (Result<MarketProducts, Error>) -> Void) {
        provider.request(.products(align: align.rawValue, page: page, size: size, category: category.rawValue, sale: sale)) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MarketProducts.self, from: data.data)
                    print("마켓조회🔥", result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
