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
    func tapNextButton()
}

protocol UniversityInfoVMOutput {
    var isHideCollectionView: BehaviorRelay<Bool> { get }
    var isHideNoAutoMakeLabel: BehaviorRelay<Bool> { get }
    var schoolSections: BehaviorRelay<[SchoolDataSection]> { get }
    var currentInputText: String { get set }
    
    var isEnableNextButton: BehaviorRelay<Bool> { get }
    
    var presentStudentAuthView: PublishRelay<StudentAuthVC> { get }
}

protocol UniversityInfoVM: UniversityInfoVMInput, UniversityInfoVMOutput {}

final class DefaultUniversityInfoVM: UniversityInfoVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    /// 전체 학교 리스트
    private let schoolList: [School] = SchoolList.loadJson()!.school
    
    // MARK: - Input
    
    func textFieldInput(_ text: String) {
        if text.isEmpty {
            isHideCollectionView.accept(true)
        } else {
            isHideCollectionView.accept(false)
        }
        
        currentInputText = text
        let filteredSchool: [SchoolData] = schoolList
            .filter { $0.koreanName.contains(text) }
            .map { SchoolData(school: $0) }
        
        if filteredSchool.isEmpty && !isHideCollectionView.value {
            isHideNoAutoMakeLabel.accept(false)
        } else {
            isHideNoAutoMakeLabel.accept(true)
        }
        
        let newSchoolSection: SchoolDataSection = .init(items: filteredSchool)
        schoolSections.accept([newSchoolSection])
    }
    
    func tapNextButton() {
        let vc = StudentAuthVC()
        presentStudentAuthView.accept(vc)
    }
    
    // MARK: - Output
    
    var isHideCollectionView: BehaviorRelay<Bool> = .init(value: true)
    var isHideNoAutoMakeLabel: BehaviorRelay<Bool> = .init(value: true)
    var schoolSections: BehaviorRelay<[SchoolDataSection]> = .init(value: [])
    var currentInputText: String = ""

    var isEnableNextButton: BehaviorRelay<Bool> = .init(value: false)
    var presentStudentAuthView: PublishRelay<StudentAuthVC> = .init()
}
