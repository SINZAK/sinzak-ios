//
//  ProductsDetailVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/28.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProductsDetailVMInput {
    func fetchProductsDetail(id: Int)
}

protocol ProductsDetailVMOutput {
    var fetchedData: PublishRelay<ProductsDetail> { get }
}

protocol ProductsDetailVM: ProductsDetailVMInput, ProductsDetailVMOutput {}

final class DefaultProductsDetailVM: ProductsDetailVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func fetchProductsDetail(id: Int) {
        ProductsManager.shared.fetchProductsDetail(id: id)
            .subscribe(
                with: self,
                onSuccess: { owner, productsDetail in
                    owner.fetchedData.accept(productsDetail)
                }, onFailure: { _, error in
                    Log.debug(error)
                })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    
    var fetchedData: PublishRelay<ProductsDetail> = .init()
    
}
