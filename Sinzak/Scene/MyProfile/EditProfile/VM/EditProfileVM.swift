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
    func nickNameTextInput(text: String)
    func checkButtonTapped()
    func completeButtonTapped(currentName: String)
    
    func introductionTextInput(text: String)
    
    var needUpdateImage: (need: Bool, image: UIImage?, isIcon: Bool?) { get set }
}

protocol EditProfileVMOutput {
    var nickNameInput: BehaviorRelay<String> { get }
    var introductionInput: BehaviorRelay<String> { get }
    
    var checkButtonIsEnable: BehaviorRelay<Bool> { get }
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> { get }
    
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
    
    func nickNameTextInput(text: String) {
        Log.debug(text)
        if text == nickNameInput.value { return }
        nickNameInput.accept(text)
        doubleCheckResult.accept(.beforeCheck)
        checkButtonIsEnable.accept(text.isValidString(.nickname))
        nickNameIsChecked = false
    }
    
    func introductionTextInput(text: String) {
        introductionInput.accept(text)
        introductionPlaceholderIsHidden.accept(!text.isEmpty)
        introductionCount.accept(text.count)
    }
    
    func checkButtonTapped() {
        Task {
            do {
                let reuslt = try await AuthManager.shared.checkNickname(for: self.nickNameInput.value)
                if reuslt {
                    doubleCheckResult.accept(.success)
                    nickNameIsChecked = true
                } else {
                    doubleCheckResult.accept(.fail)
                }
            } catch {
                APIError.logError(error)
            }
        }
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
        
        Log.debug(nickNameIsChecked)
        Log.debug(nickNameInput.value)
        Log.debug(currentName)
        
        let name = nickNameIsChecked ? nickNameInput.value : currentName
        tasks.append(
            UserCommandManager.shared.editUserInfo(
                name: name,
                introduction: introductionInput.value
            )
            .asObservable()
        )
        
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
    
    var nickNameInput: BehaviorRelay<String> = .init(value: "")
    var introductionInput: BehaviorRelay<String> = .init(value: "")
    
    var checkButtonIsEnable: BehaviorRelay<Bool> = .init(value: false)
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> = .init(value: .beforeCheck)
    
    var introductionPlaceholderIsHidden: PublishRelay<Bool> = .init()
    var introductionCount: PublishRelay<Int> = .init()
        
    var updateSchoolAuth: PublishRelay<String> = .init()
    var updateGenre: PublishRelay<[AllGenre]> = .init()
    
    var completeEditTasks: PublishRelay<Bool> = .init()
    
    var errorHandler: PublishRelay<Error> = .init()
}
