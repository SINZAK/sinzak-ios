//
//  SignupGenreVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol SignupGenreVMInput {
    
}

protocol SignupGenreVMOutput {
    
}

protocol SignupGenreVM: SignupGenreVMInput, SignupGenreVMOutput {}

final class DefaultSignupGenreVM: SignupGenreVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    // MARK: - Output
    
}
