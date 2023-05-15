//
//  EditProfileVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditProfileVMInput {
    func nickNameTextInput(text: String)
    func checkButtonTapped()
    
    func introductionTextInput(text: String)
}

protocol EditProfileVMOutput {
    var nickNameInput: BehaviorRelay<String> { get }
    var checkButtonIsEnable: BehaviorRelay<Bool> { get }
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> { get }
    
    var introductionPlaceholderIsHidden: PublishRelay<Bool> { get }
    var introductionCount: PublishRelay<Int> { get }
}

protocol EditProfileVM: EditProfileVMInput, EditProfileVMOutput {}

final class DefaultEditProfileVM: EditProfileVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func nickNameTextInput(text: String) {
        nickNameInput.accept(text)
        checkButtonIsEnable.accept(text.isValidString(.nickname))
    }
    
    func introductionTextInput(text: String) {
        introductionPlaceholderIsHidden.accept(!text.isEmpty)
        introductionCount.accept(text.count)
    }
    
    func checkButtonTapped() {
        Task {
            do {
                let reuslt = try await AuthManager.shared.checkNickname(for: self.nickNameInput.value)
                if reuslt {
                    doubleCheckResult.accept(.sucess("멋진 이름이네요!", CustomColor.red))
                } else {
                    doubleCheckResult.accept(.fail("사용불가능한 이름입니다.", CustomColor.purple))
                }
            } catch {
                APIError.logError(error)
            }
        }
    }
    
    // MARK: - Output
    
    var nickNameInput: BehaviorRelay<String> = .init(value: "")
    var checkButtonIsEnable: BehaviorRelay<Bool> = .init(value: false)
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> = .init(value: .beforeCheck)
    
    var introductionPlaceholderIsHidden: PublishRelay<Bool> = .init()
    var introductionCount: PublishRelay<Int> = .init()
    
}
