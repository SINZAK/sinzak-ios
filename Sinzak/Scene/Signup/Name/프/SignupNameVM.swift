//
//  SignupNameVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol SignupNameVMInput {
    
}

protocol SignupNameVMOutput {
    
}

protocol SignupNameVM: SignupNameVMInput, SignupNameVMOutput {}

final class DefaultSignupNameVM: SignupNameVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    // MARK: - Output
    
}
