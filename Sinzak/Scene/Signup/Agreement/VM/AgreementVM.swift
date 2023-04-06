//
//  AgreementVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol AgreementVMInput {
    
}

protocol AgreementVMOutput {
    
}

protocol AgreementVM: AgreementVMInput, AgreementVMOutput {}

final class DefaultAgreementVM: AgreementVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    // MARK: - Output
    
}
