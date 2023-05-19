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
}

protocol WritePostVMOutput {
    
    var photoSections: BehaviorRelay<[PhotoSection]> { get }
    
}

protocol WritePostVM: WritePostVMInput, WritePostVMOutput {}

final class DefaultAddPhotosVM: WritePostVM {
    
    private let disposeBag = DisposeBag()
    
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
    
    // MARK: - Output
    
    var photoSections: BehaviorRelay<[PhotoSection]> = .init(
        value: [PhotoSection(model: "", items: [UIImage()])]
    )
    
}
