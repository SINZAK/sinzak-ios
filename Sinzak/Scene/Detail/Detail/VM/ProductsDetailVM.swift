//
//  ProductsDetailVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias ImageSection = SectionModel<Void, String>

protocol ProductsDetailVMInput {
    func fetchProductsDetail(id: Int)
    var refresh: () -> Void { get }
    func requestDeal(postID: Int, postType: String)
}

protocol ProductsDetailVMOutput {
    var fetchedData: PublishRelay<ProductsDetail> { get }
    var imageSections: PublishRelay<[ImageSection]> { get }
    
    var deletedPost: PublishRelay<String> { get }
    var pushChatRoom: PublishRelay<ChatVC> { get }
    
    var errorHandler: PublishRelay<Error> { get }
}

protocol ProductsDetailVM: ProductsDetailVMInput, ProductsDetailVMOutput {}

final class DefaultProductsDetailVM: ProductsDetailVM {
    
    private let disposeBag = DisposeBag()
    
    var type: DetailType

    init(type: DetailType, refresh: @escaping () -> Void) {
        self.type = type
        self.refresh = refresh
    }
    
    // MARK: - Input
    
    func fetchProductsDetail(id: Int) {
        let detail: Single<ProductsDetail>
        
        switch type {
        case .purchase:
            detail = ProductsManager.shared.fetchProductsDetail(id: id)
        case .request:
            detail = WorksManager.shared.fetchWorksDetail(id: id)
        }
        
        detail
            .subscribe(
                with: self,
                onSuccess: { owner, productsDetail in
                    owner.fetchedData.accept(productsDetail)
                    
                    if let images = productsDetail.images, images.isEmpty {
                        owner.imageSections.accept(
                            [ImageSection(model: Void(), items: ["empty"])]
                        )
                    } else if let images = productsDetail.images, !images.isEmpty {
                        owner.imageSections.accept(
                            [ImageSection(model: Void(), items: productsDetail.images ?? [])]
                        )
                    }
                }, onFailure: { owner, error in
                    if error is APIError {
                        let error = error as! APIError
                        switch error {
                        case .errorMessage(let message):
                                owner.deletedPost.accept(message)
                        default:
                            Log.error(error)
                        }
                    } else {
                        Log.error(error)
                    }
                })
            .disposed(by: disposeBag)
    }
    
    func requestDeal(postID: Int, postType: String) {
        
        ChatManager.shared.creatChatRoom(postID: postID, postType: postType)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                with: self,
                onSuccess: { owner, roomID in
                    let vm = DefaultChatVM(roomID: roomID)
                    let vc = ChatVC(viewModel: vm)
                    owner.pushChatRoom.accept(vc)
                },
                onFailure: { owner, error in
                    owner.errorHandler.accept(error)
                })
            .disposed(by: disposeBag)
        
    }
    
    var refresh: () -> Void

    // MARK: - Output
    
    var fetchedData: PublishRelay<ProductsDetail> = .init()
    var imageSections: PublishRelay<[ImageSection]> = .init()
    var pushChatRoom: PublishRelay<ChatVC> = .init()
    
    var deletedPost: PublishRelay<String> = .init()
    
    var errorHandler: PublishRelay<Error> = .init()
}
