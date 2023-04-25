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
    func fetchProducts(
        align: AlignOption,
        category: [CategoryType],
        page: Int,
        size: Int,
        sale: Bool
    ) -> Single<[Products]>
}

class ProductsManager: ProductManagerType {
    private init () {}
    static let shared = ProductsManager()
    let provider = MoyaProvider<ProductsAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    private let disposeBag = DisposeBag()
    
    /// 상품들 가져올때 사용
    func fetchProducts(
        align: AlignOption,
        category: [CategoryType],
        page: Int,
        size: Int,
        sale: Bool
    ) -> Single<[Products]> {
        return provider.rx.request(.products(
            align: align.rawValue,
            page: page,
            size: size,
            category: category.map { $0.rawValue },
            sale: sale
        ))
        .filterSuccessfulStatusCodes()
        .map(MarketProductsResponseDTO.self)
        .map({ productsResponseDTO in
            guard let productsDTO = productsResponseDTO.content else {
                throw APIError.noContent
            }
            return productsDTO.map { $0.toDomain() }
        })
        .retry(2)
    }
    
    func fetchProductsDetail(id: Int) -> Single<ProductsDetail> {
        return provider.rx.request(.productDetail(id: id))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<ProductsDetailDTO>.self)
            .map { result in
                if !result.success {
                    throw APIError.errorMessage(result.message ?? "")
                }
                
                guard let data = result.data?.toDomain() else {
                    throw APIError.noContent
                }
                
                return data
            }
            
    }
    
    func likeProducts(id: Int, mode: Bool) -> Single<Bool> {
        return provider.rx.request(.like(id: id, mode: mode))
            .filterSuccessfulStatusCodes()
            .map(LikeResponseDTO.self)
            .map { response in
                Log.debug(response)
                Log.debug(response)
                Log.debug(response)
                Log.debug(response)
                Log.debug(response)
                if !response.success {
                    throw APIError.errorMessage("like error")
                }
                
                
                return response.success
            }
    }
}
