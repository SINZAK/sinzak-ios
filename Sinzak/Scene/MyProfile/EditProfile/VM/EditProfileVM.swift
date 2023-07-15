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
    var changedNicknameRelay: PublishRelay<String> { get }
    var changedIntroductionRelay: PublishRelay<String> { get }
    
    var updateSchoolAuthRelay: PublishRelay<String> { get }
    var updateGenreRelay: PublishRelay<[AllGenre]> { get }
    
    var completeEditTasksRelay: PublishRelay<Bool> { get }
    
    var errorHandlerRelay: PublishRelay<Error> { get }
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
                    owner.completeEditTasksRelay.accept(true)
                },
                onFailure: { owner, error in
                    Log.error(error)
                    owner.errorHandlerRelay.accept(error)
                }
            )
            .disposed(by: disposeBag)
        } else {
            completeEditTasksRelay.accept(true)
        }
    }
    
    // MARK: - Output
    
    var changedNicknameRelay: PublishRelay<String> = .init()
    var changedIntroductionRelay: PublishRelay<String> = .init()
    
    var introductionPlaceholderIsHidden: PublishRelay<Bool> = .init()
    var introductionCount: PublishRelay<Int> = .init()
        
    var updateSchoolAuthRelay: PublishRelay<String> = .init()
    var updateGenreRelay: PublishRelay<[AllGenre]> = .init()
    
    var completeEditTasksRelay: PublishRelay<Bool> = .init()
    
    var errorHandlerRelay: PublishRelay<Error> = .init()
}
