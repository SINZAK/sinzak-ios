//
//  SignupNameVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/07.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol SignupNameVMInput {
    func nameTextFieldInput(name: String)
    func tapCheckButton()
    func tapNextButton()
}

protocol SignupNameVMOutput {
    var isValidCheckButton: BehaviorRelay<Bool> { get }
    var currentInputName: BehaviorRelay<String> { get }
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> { get }
    var pushSignupGenreVC: PublishRelay<SignupGenreVC> { get }
}

protocol SignupNameVM: SignupNameVMInput, SignupNameVMOutput {}

final class DefaultSignupNameVM: SignupNameVM {
    
    private let disposeBag = DisposeBag()
    
    private var onboardingUser: OnboardingUser
    
    init(onboardingUser: OnboardingUser) {
        self.onboardingUser = onboardingUser
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
        onboardingUser.nickname = currentInputName.value
        let vc = SignupGenreVC(viewModel: DefaultSignupGenreVM(onboardingUser: onboardingUser), mode: .signUp)
        pushSignupGenreVC.accept(vc)
    }
    
    // MARK: - Output
    var isValidCheckButton: BehaviorRelay<Bool> = .init(value: false)
    var currentInputName: BehaviorRelay<String> = .init(value: "")
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> = .init(value: .beforeCheck)
    var pushSignupGenreVC: PublishRelay<SignupGenreVC> = .init()
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
