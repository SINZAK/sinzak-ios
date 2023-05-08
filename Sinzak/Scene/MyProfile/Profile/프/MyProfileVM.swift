//
//  MyProfileVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol MyProfileVMInput {
    
}

protocol MyProfileVMOutput {
    
}

protocol MyProfileVM: MyProfileVMInput, MyProfileVMOutput {}

final class DefaultMyProfileVM: MyProfileVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    // MARK: - Output
    
}
