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
        align: AlignOption,
        category: [Category],
        page: Int,
        size: Int,
        sale: Bool
    ) -> Single<[MarketProduct]> {
        return Single<[MarketProduct]>.create { [weak self] single in
            guard let self = self else {
                return Disposables.create {}
            }
            
            self.provider.rx.request(.products(
                align: align.rawValue,
                page: page,
                size: size,
                category: category.map { $0.rawValue },
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
                        guard let content = try JSONDecoder().decode(MarketProductsResponseDTO.self, from: response.data).content else {
                            Log.debug("content가 없습니다!")
                            return
                        }
                        
                        let marketProducts = content.map { responseDTO in
                            responseDTO.toDomain()
                        }
                        
                        Log.debug(marketProducts)
                        single(.success(marketProducts))
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
