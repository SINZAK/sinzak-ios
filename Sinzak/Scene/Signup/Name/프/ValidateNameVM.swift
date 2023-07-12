//
//  ValidateNameVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/07.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ValidateNameVMInput {
    func nameTextFieldInput(name: String)
    func tapCheckButton()
    func tapNextButton()
    func editNickname(nickname: String)
}

protocol ValidateNameVMOutput {
    var isValidCheckButton: BehaviorRelay<Bool> { get }
    var currentInputName: BehaviorRelay<String> { get }
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> { get }
    var pushSignupGenreVC: PublishRelay<SignupGenreVC> { get }
    var dismissView: PublishRelay<Bool> { get }
    
    var changedNickname: PublishRelay<String>? { get }
}

protocol ValidateNameVM: ValidateNameVMInput, ValidateNameVMOutput {}

final class DefaultValidateNameVM: ValidateNameVM {
    
    private let disposeBag = DisposeBag()
    
    private var onboardingUser: OnboardingUser?
    
    private var introduction: String?
    
    init(onboardingUser: OnboardingUser) {
        self.onboardingUser = onboardingUser
    }
    
    init(
        introduction: String,
        changedNickname: PublishRelay<String>
    ) {
        self.introduction = introduction
        self.changedNickname = changedNickname
    }
    
    // MARK: - Input
    
    func nameTextFieldInput(name: String) {
        doubleCheckResult.accept(.beforeCheck)
        if isValidCheckButton.value != name.isValidString(.nickname) {
            isValidCheckButton.accept(name.isValidString(.nickname))
        }
        currentInputName.accept(name)
    }
    
    func tapCheckButton() {
        Task {
            do {
                let reuslt = try await AuthManager.shared.checkNickname(for: self.currentInputName.value)
                if reuslt {
                    doubleCheckResult.accept(.success)
                } else {
                    doubleCheckResult.accept(.fail)
                }
            } catch {
                APIError.logError(error)
            }
        }
    }
    
    func tapNextButton() {
        onboardingUser?.nickname = currentInputName.value
        let vc = SignupGenreVC(viewModel: DefaultSignupGenreVM(onboardingUser: onboardingUser), mode: .signUp)
        pushSignupGenreVC.accept(vc)
    }
    
    func editNickname(nickname: String) {
        UserCommandManager.shared.editUserInfo(
            name: nickname,
            introduction: ""
        )
        .subscribe(
            with: self,
            onSuccess: { owner, _ in
                owner.changedNickname?.accept(nickname)
                owner.dismissView.accept(true)
            },
            onFailure: { _, error in
                Log.debug(error)
            }
        )
        .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    var isValidCheckButton: BehaviorRelay<Bool> = .init(value: false)
    var currentInputName: BehaviorRelay<String> = .init(value: "")
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> = .init(value: .beforeCheck)
    var pushSignupGenreVC: PublishRelay<SignupGenreVC> = .init()
    var dismissView: PublishRelay<Bool> = .init()
    var changedNickname: PublishRelay<String>?
}

enum DoubleCheckResult {
    case beforeCheck
    case success
    case fail
    
    var info: String {
        switch self {
        case .beforeCheck:      return ""
        case .success:           return "멋진 이름이네요!"
        case .fail:             return "사용불가능한 이름입니다."
        }
    }
    
    var color: UIColor {
        switch self {
        case .beforeCheck:      return CustomColor.label
        case .success:           return CustomColor.red
        case .fail:             return CustomColor.purple
        }
    }
}
