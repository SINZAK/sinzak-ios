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
    func tapNotStudentButton()
    func tapNextButton(univName: String, mode: EditViewMode)
}

protocol UniversityInfoVMOutput {
    var isHideCollectionView: BehaviorRelay<Bool> { get }
    var isHideNoAutoMakeLabel: BehaviorRelay<Bool> { get }
    var schoolSections: BehaviorRelay<[SchoolDataSection]> { get }
    var currentInputText: String { get set }
    
    var isEnableNextButton: BehaviorRelay<Bool> { get }
    
    var presentWelcomeView: PublishRelay<WelcomeVC> { get }
    var pushStudentAuthView: PublishRelay<StudentAuthVC> { get }
}

protocol UniversityInfoVM: UniversityInfoVMInput, UniversityInfoVMOutput {}

final class DefaultUniversityInfoVM: UniversityInfoVM {
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    
    var updateSchoolAuth: PublishRelay<String>?
    
    /// 전체 학교 리스트
    private let schoolList: [School] = SchoolList.loadJson()!.school
    
    init(updateSchoolAuth: PublishRelay<String>? = nil) {
        self.updateSchoolAuth = updateSchoolAuth
    }
    
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
    
    func tapNotStudentButton() {
        let vc = WelcomeVC()
        presentWelcomeView.accept(vc)
    }
    
    func tapNextButton(univName: String, mode: EditViewMode) {
        let vm = DefaultStudentAuthVM(
            univName: univName,
            updateSchoolAuth: updateSchoolAuth
        )
        let vc = StudentAuthVC(viewModel: vm, mode: mode)
        pushStudentAuthView.accept(vc)
    }

    // MARK: - Output
    
    var isHideCollectionView: BehaviorRelay<Bool> = .init(value: true)
    var isHideNoAutoMakeLabel: BehaviorRelay<Bool> = .init(value: true)
    var schoolSections: BehaviorRelay<[SchoolDataSection]> = .init(value: [])
    var currentInputText: String = ""

    var isEnableNextButton: BehaviorRelay<Bool> = .init(value: false)
    
    var presentWelcomeView: PublishRelay<WelcomeVC> = .init()
    var pushStudentAuthView: PublishRelay<StudentAuthVC> = .init()
}
