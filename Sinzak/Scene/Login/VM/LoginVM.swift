//
//  LoginVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/03.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol LoginVMInput {

}

protocol LoginVMOutput {
    
}

protocol LoginVM: LoginVMInput, LoginVMOutput {}

final class DefaultLoginVM: LoginVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    // MARK: - Output
    
}
