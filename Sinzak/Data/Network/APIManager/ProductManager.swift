//
//  ProductManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import Foundation
import RxSwift
import Moya

protocol ProductManagerType {
    
}

class ProductsManager {
    private init () {}
    static let shared = ProductsManager()
    let provider = MoyaProvider<ProductsAPI>()
    private let disposeBag = DisposeBag()
    
    func fetchProducts(
        aligh: AlignOption,
        category: Category,
        page: Int,
        size: Int,
        sale: Bool
    ) -> Single<MarketProducts> {
        return Single<MarketProducts>.create { [weak self] single in
            guard let self = self else {
                return Disposables.create {}
            }
            
            self.provider.rx.request(.products(
                align: aligh.rawValue,
                page: page,
                size: size,
                category: category.rawValue,
                sale: sale
            ))
            .subscribe { event in
                switch event {
                case let .success(response):
                    
                    Log.debug(response.request?.url ?? "url이 없습니다.")
                    
                    guard 200..<299 ~= response.statusCode else {
                        single(.failure(APIErrors.badStatus(code: response.statusCode)))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(MarketProducts.self, from: response.data)
                        Log.debug(result)
                        single(.success(result))
                    } catch {
                        single(.failure(APIErrors.decodingError))
                    }
                    
                case let .failure(error):
                    single(.failure(APIErrors.unknown(error)))
                }
            }
            .disposed(by: self.disposeBag)
            return Disposables.create {}
        }
    }
}
