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
    ) -> Single<[MarketProduct]>
}

class ProductsManager: ProductManagerType {
    private init () {}
    static let shared = ProductsManager()
    let provider = MoyaProvider<ProductsAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    private let disposeBag = DisposeBag()
    
    func fetchProducts(
        align: AlignOption,
        category: [CategoryType],
        page: Int,
        size: Int,
        sale: Bool
    ) -> Single<[MarketProduct]> {
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
}
