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
        category: [Category],
        page: Int,
        size: Int,
        sale: Bool
    ) -> Single<[MarketProduct]>
}

class ProductsManager: ProductManagerType {
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
        return provider.rx.request(.products(
            align: align.rawValue,
            page: page,
            size: size,
            category: category.map { $0.rawValue },
            sale: sale
        ))
        .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
        .map { response in
            Log.debug("Thread: \(Thread.current)")
            if !(200..<300 ~= response.statusCode) {
                throw APIError.badStatus(code: response.statusCode)
            }
            Log.debug(response.request?.url ?? "")
            
            do {
                let productsResponseDTO = try JSONDecoder().decode(
                    MarketProductsResponseDTO.self,
                    from: response.data
                )
                guard let productsDTO = productsResponseDTO.content else {
                    throw APIError.noContent
                }
                return productsDTO.map { $0.toDomain() }
            } catch {
                throw APIError.decodingError
            }
        }
    }
}
