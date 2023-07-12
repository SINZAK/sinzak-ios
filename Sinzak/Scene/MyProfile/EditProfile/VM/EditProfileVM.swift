//
//  EditProfileVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/15.
//

import UIKit
import RxSwift
import RxCocoa

protocol EditProfileVMInput {
    func completeButtonTapped(currentName: String)
    
    var needUpdateImage: (need: Bool, image: UIImage?, isIcon: Bool?) { get set }
}

protocol EditProfileVMOutput {
    var changedNickname: PublishRelay<String> { get }
    var changedIntroduction: PublishRelay<String> { get }
    
    var updateSchoolAuth: PublishRelay<String> { get }
    var updateGenre: PublishRelay<[AllGenre]> { get }
    
    var completeEditTasks: PublishRelay<Bool> { get }
    
    var errorHandler: PublishRelay<Error> { get }
}

protocol EditProfileVM: EditProfileVMInput, EditProfileVMOutput {}

final class DefaultEditProfileVM: EditProfileVM {
    
    private let disposeBag = DisposeBag()
    
    private var nickNameIsChecked: Bool = false
    var needUpdateImage: (need: Bool, image: UIImage?, isIcon: Bool?) = (false, nil, nil)
    
    // MARK: - Input
    
    func completeButtonTapped(currentName: String) {
        
        if needUpdateImage.need {
            UserCommandManager.shared.editUserImage(
                image: needUpdateImage.image ?? UIImage(),
                isIcon: needUpdateImage.isIcon ?? false
            )
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    owner.completeEditTasks.accept(true)
                },
                onFailure: { owner, error in
                    Log.error(error)
                    owner.errorHandler.accept(error)
                }
            )
            .disposed(by: disposeBag)
        } else {
            completeEditTasks.accept(true)
        }
    }
    
    // MARK: - Output
    
    var changedNickname: PublishRelay<String> = .init()
    var changedIntroduction: PublishRelay<String> = .init()
    
    var introductionPlaceholderIsHidden: PublishRelay<Bool> = .init()
    var introductionCount: PublishRelay<Int> = .init()
        
    var updateSchoolAuth: PublishRelay<String> = .init()
    var updateGenre: PublishRelay<[AllGenre]> = .init()
    
    var completeEditTasks: PublishRelay<Bool> = .init()
    
    var errorHandler: PublishRelay<Error> = .init()
}
