//
//  WorksManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/04.
//

import Foundation
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
}