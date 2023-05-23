//
//  WorksManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/04.
//

import UIKit
import Moya
import RxSwift

final class WorksManager: ManagerType {
    
    static var shared = WorksManager()
    private init() {}
    
    let provider = MoyaProvider<WorksAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    private let diposeBag = DisposeBag()
    
    func fetchWorks(
        employment: Bool,
        align: AlignOption,
        category: [WorksCategory],
        page: Int,
        size: Int,
        sale: Bool,
        search: String
    ) -> Single<[Products]> {
        return provider.rx.request(.works(
            employment: employment,
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
    
    func fetchWorksDetail(id: Int) -> Single<ProductsDetail> {
        return provider.rx.request(.worksDetail(id: id))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<ProductsDetailDTO>.self)
            .map(filterError)
            .map(getData)
            .map { $0.toDomain() }
    }
    
    func deleteWorks(id: Int) -> Single<Bool> {
        return provider.rx.request(.delete(id: id))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func likeWorks(id: Int, mode: Bool) -> Single<Bool> {
        return provider.rx.request(.like(id: id, mode: mode))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func wishWorks(id: Int, mode: Bool) -> Single<Bool> {
        return provider.rx.request(.wish(id: id, mode: mode))
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
    
    func completeWorks(id: Int) -> Single<Bool> {
        return provider.rx.request(.sell(postId: id))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func buildWorksPost(works: WorkBuild, images: [UIImage]) -> Single<Bool> {
        return provider.rx.request(.build(post: works))
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
                
                return self.worksImageUpload(id: id, images: images)
            }
    }
    
    private func worksImageUpload(id: Int, images: [UIImage]) -> Single<Bool> {
        return provider.rx.request(.imageUpload(id: id, images: images))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
}
