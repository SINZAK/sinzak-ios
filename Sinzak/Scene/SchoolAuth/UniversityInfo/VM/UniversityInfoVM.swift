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
    var schoolSections: BehaviorRelay<[SchoolDataSection]> { get }
}

protocol UniversityInfoVM: UniversityInfoVMInput, UniversityInfoVMOutput {}

final class DefaultUniversityInfoVM: UniversityInfoVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    /// 전체 학교 리스트
    let schoolList: [School] = SchoolList.loadJson()!.school
    
    // MARK: - Input
    
    func textFieldInput(_ text: String) {
        if text.isEmpty {
            isCollectionViewHide.accept(true)
        } else {
            isCollectionViewHide.accept(false)
        }
        
        let filteredSchool: [SchoolData] = schoolList
            .filter { $0.koreanName.contains(text) }
            .map { SchoolData(school: $0) }
        
        let newSchoolSection: SchoolDataSection = .init(items: filteredSchool)
        schoolSections.accept([newSchoolSection])

    }
    
    // MARK: - Output
    
    var isCollectionViewHide: BehaviorRelay<Bool> = .init(value: true)
    var schoolSections: BehaviorRelay<[SchoolDataSection]> = .init(value: [])
    
}
