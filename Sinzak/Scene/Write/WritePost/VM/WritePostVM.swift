//
//  WritePostVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias PhotoSection = SectionModel<String, UIImage>

protocol WritePostVMInput {
    
    func photoSelected(images: [UIImage])
    func deleteImage(image: UIImage)
    
    func postProductsComplete(
        title: String,
        price: Int,
        suggest: Bool,
        body: String,
        width: Int,
        vertical: Int,
        heigth: Int
    )
    
    func postWorksComplete(
        title: String,
        price: Int,
        suggest: Bool,
        body: String
    )
}

protocol WritePostVMOutput {
    
    var photoSections: BehaviorRelay<[PhotoSection]> { get }
    
    var needDismiss: PublishRelay<Bool> { get }
    var hideLoadingRelay: PublishRelay<Bool> { get }
    
}

protocol WritePostVM: WritePostVMInput, WritePostVMOutput {}

final class DefaultAddPhotosVM: WritePostVM {
    
    let selectedCategory: WriteCategory
    let selectedGenres: [String]
    
    private let disposeBag = DisposeBag()
    
    init(
        selectedCategory: WriteCategory,
        selectedGenres: [String]
    ) {
        self.selectedCategory = selectedCategory
        self.selectedGenres = selectedGenres
    }
    
    // MARK: - Input
    
    func photoSelected(images: [UIImage]) {
        if images.isEmpty { return }
        let current = photoSections.value[0].items
        let photoSection = PhotoSection(model: "", items: current + images)
        photoSections.accept([photoSection])
    }
    
    func deleteImage(image: UIImage) {
        let images = photoSections.value[0].items.filter { $0 != image }
        let section = PhotoSection(model: "", items: images)
        
        photoSections.accept([section])
    }
    
    func postProductsComplete(
        title: String,
        price: Int,
        suggest: Bool,
        body: String,
        width: Int,
        vertical: Int,
        heigth: Int
    ) {
        
        let marketBuild = MarketBuild(
            category: selectedGenres.joined(separator: ","),
            title: title,
            content: body,
            height: heigth,
            vertical: vertical,
            width: width,
            suggest: suggest,
            price: price
        )
        
        let images: [UIImage] = photoSections.value[0].items
        
        ProductsManager.shared.buildProductsPost(
            products: marketBuild,
            images: images
        )
        .subscribe(
            with: self,
            onSuccess: { owner, _ in
                owner.compltePost()
            },
            onFailure: { owner, error in
                Log.error(error)
                owner.hideLoadingRelay.accept(true)
            })
        .disposed(by: disposeBag)
    }
    
    func postWorksComplete(
        title: String,
        price: Int,
        suggest: Bool,
        body: String
    ) {
        let worksBuild = WorkBuild(
            category: selectedGenres.joined(separator: ","),
            title: title,
            content: body,
            employment: selectedCategory == .request,
            price: price,
            suggest: suggest
        )
        
        let images: [UIImage] = photoSections.value[0].items
        WorksManager.shared.buildWorksPost(works: worksBuild, images: images)
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    owner.compltePost()
                },
                onFailure: { owner, error in
                    Log.error(error)
                    owner.hideLoadingRelay.accept(true)
                })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Output
    
    var photoSections: BehaviorRelay<[PhotoSection]> = .init(
        value: [PhotoSection(model: "", items: [UIImage()])]
    )
    
    var needDismiss: PublishRelay<Bool> = .init()
    var hideLoadingRelay: PublishRelay<Bool> = .init()
}

private extension DefaultAddPhotosVM {
    
    func compltePost() {
        hideLoadingRelay.accept(true)
        NotificationCenter.default.post(name: .completePost, object: selectedCategory)
        needDismiss.accept(true)
    }
    
}
