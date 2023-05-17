//
//  AddPhotosVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias PhotoSection = AnimatableSectionModel<String, Photo>

protocol AddPhotosVMInput {
    
    func photoSelected(images: [UIImage])
    
}

protocol AddPhotosVMOutput {
    
    var photoSections: BehaviorRelay<[PhotoSection]> { get }
    
}

protocol AddPhotosVM: AddPhotosVMInput, AddPhotosVMOutput {}

final class DefaultAddPhotosVM: AddPhotosVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func photoSelected(images: [UIImage]) {
        if images.isEmpty { return }
        
        let photos = images.map { Photo(image: $0) }
        let photoSection = PhotoSection(model: "", items: photos)
        
        photoSections.accept([photoSection])
        Log.debug(photoSections.value)
    }
    
    // MARK: - Output
    
    var photoSections: BehaviorRelay<[PhotoSection]> = .init(value: [])
    
}
