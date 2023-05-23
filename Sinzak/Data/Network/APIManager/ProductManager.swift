//
//  ProductManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import UIKit
import RxSwift
import Moya

class ProductsManager: ManagerType {
    
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
        category: [ProductsCategory],
        page: Int,
        size: Int,
        sale: Bool,
        search: String
    ) -> Single<[Products]> {
        return provider.rx.request(.products(
            align: align.rawValue,
            page: page,
            size: size,
            category: category.map { $0.rawValue },
            sale: sale,
            search: search
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
            .map(filterError)
            .map(getData)
            .map { $0.toDomain() }
    }
    
    func likeProducts(id: Int, mode: Bool) -> Single<Bool> {
        return provider.rx.request(.like(id: id, mode: mode))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func wishProducts(id: Int, mode: Bool) -> Single<Bool> {
        return provider.rx.request(.wish(id: id, mode: mode))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func deleteProducts(id: Int) -> Single<Bool> {
        return provider.rx.request(.delete(id: id))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    /// 거래 완료, 의뢰 완료 처리
    func completeProducts(id: Int) -> Single<Bool> {
        return provider.rx.request(.sell(postId: id))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func suggestPrice(id: Int, price: Int) -> Single<Bool> {
        return provider.rx.request(.priceSuggest(id: id, price: price))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func buildProductsPost(products: MarketBuild, images: [UIImage]) -> Single<Bool> {
        return provider.rx.request(.build(post: products))
            .filterSuccessfulStatusCodes()
            .map(BuildPostResponseDTO.self)
            .map { response in
                guard response.success == true else {
                    throw APIError.errorMessage(response.message ?? "")
                }
                
                return response.id ?? -1
            }
            .flatMap { [weak self] id -> Single<Bool> in
                guard let self = self else { return Observable.just(false).asSingle() }
                
                return self.productsImageUpload(id: id, images: images)
            }
    }
    
    private func productsImageUpload(id: Int, images: [UIImage]) -> Single<Bool> {
        return provider.rx.request(.imageUpload(id: id, images: images))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
}
