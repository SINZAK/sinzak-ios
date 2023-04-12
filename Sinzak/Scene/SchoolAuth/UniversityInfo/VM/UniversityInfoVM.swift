//
//  UniversityInfoVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/13.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol UniversityInfoVMInput {
    func textFieldInput(_ text: String)
}

protocol UniversityInfoVMOutput {
    var isCollectionViewHide: BehaviorRelay<Bool> { get }
}

protocol UniversityInfoVM: UniversityInfoVMInput, UniversityInfoVMOutput {}

final class DefaultUniversityInfoVM: UniversityInfoVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    let schoolList: [String] = SchoolList.loadJson()!.school.compactMap { $0.koreanName }
    
    // MARK: - Input
    
    func textFieldInput(_ text: String) {
        if text.isEmpty {
            isCollectionViewHide.accept(true)
        } else {
            isCollectionViewHide.accept(false)
        }
        print(text)
    }
    
    // MARK: - Output
    
    var isCollectionViewHide: BehaviorRelay<Bool> = .init(value: true)
    
}
