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
}

protocol SignupNameVMOutput {
    var isValidCheckButton: BehaviorRelay<Bool> { get }
    var currentInputName: BehaviorRelay<String> { get }
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> { get }
}

protocol SignupNameVM: SignupNameVMInput, SignupNameVMOutput {}

final class DefaultSignupNameVM: SignupNameVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func nameTextFieldInput(name: String) {
        doubleCheckResult.accept(.beforeCheck)
        if isValidCheckButton.value != name.isValidString(.nickname) {
            isValidCheckButton.accept(name.isValidString(.nickname))
            currentInputName.accept(name)
        }
    }
    
    func tapCheckButton() {
        Task {
            do {
                let reuslt = try await AuthManager.shared.checkNickname(for: self.currentInputName.value)
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
    var isValidCheckButton: BehaviorRelay<Bool> = .init(value: false)
    var currentInputName: BehaviorRelay<String> = .init(value: "")
    var doubleCheckResult: BehaviorRelay<DoubleCheckResult> = .init(value: .beforeCheck)
}

enum DoubleCheckResult {
    case beforeCheck
    case sucess(String, UIColor?)
    case fail(String, UIColor?)
}
