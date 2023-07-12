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
    
    func introductionTextInput(text: String)
    
    var needUpdateImage: (need: Bool, image: UIImage?, isIcon: Bool?) { get set }
}

protocol EditProfileVMOutput {
    var changedNickname: PublishRelay<String> { get }
    var introductionInput: BehaviorRelay<String> { get }
    
    var introductionPlaceholderIsHidden: PublishRelay<Bool> { get }
    var introductionCount: PublishRelay<Int> { get }
    
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
        
    func introductionTextInput(text: String) {
        introductionInput.accept(text)
        introductionPlaceholderIsHidden.accept(!text.isEmpty)
        introductionCount.accept(text.count)
    }
    
    func completeButtonTapped(currentName: String) {
        
        var tasks: [Observable<Bool>] = []
        
        if needUpdateImage.need {
            tasks.append(
                UserCommandManager.shared.editUserImage(
                    image: needUpdateImage.image ?? UIImage(),
                    isIcon: needUpdateImage.isIcon ?? false
                )
                .asObservable()
            )
        }
        
        Observable.zip(tasks)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.completeEditTasks.accept(true)
                },
                onError: { owner, error in
                    owner.errorHandler.accept(error)
                })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    
    var changedNickname: PublishRelay<String> = .init()
    var introductionInput: BehaviorRelay<String> = .init(value: "")
    
    var introductionPlaceholderIsHidden: PublishRelay<Bool> = .init()
    var introductionCount: PublishRelay<Int> = .init()
        
    var updateSchoolAuth: PublishRelay<String> = .init()
    var updateGenre: PublishRelay<[AllGenre]> = .init()
    
    var completeEditTasks: PublishRelay<Bool> = .init()
    
    var errorHandler: PublishRelay<Error> = .init()
}
