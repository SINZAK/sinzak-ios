//
//  StudentAuthVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/15.
//

import UIKit
import RxSwift
import RxCocoa

protocol StudentAuthVMInput {
    
    func webMailTextInput(text: String)
    func tranmitUnivMail()
    func certifyUnivEmailCode(code: Int)
    
    func transmitSchoolCar(image: UIImage)
}

protocol StudentAuthVMOutput {
    var webMailTextValidResult: BehaviorRelay<WebMailTextValidResult> { get }
    
    var showAuthCodeView: PublishRelay<Bool> { get }
    var completeEmailCertify: PublishRelay<Bool> { get }
    var completeSchoolCardCertify: PublishRelay<Bool> { get }
        
    var errorHandler: PublishRelay<Error> { get }
}

protocol StudentAuthVM: StudentAuthVMInput, StudentAuthVMOutput {}

final class DefaultStudentAuthVM: StudentAuthVM {
    
    var currentWebMail: String = ""
    var univName: String
    var updateSchoolAuth: PublishRelay<String>?
    private let disposeBag = DisposeBag()
    
    init(
        univName: String,
        updateSchoolAuth: PublishRelay<String>? = nil
    ) {
        self.univName = univName
        self.updateSchoolAuth = updateSchoolAuth
    }
    
    // MARK: - Input
    
    func webMailTextInput(text: String) {
        currentWebMail = text
        
        if text.isEmpty {
            webMailTextValidResult.accept(.empty)
            return
        }
        switch text.isValidString(.email) {
        case true:      webMailTextValidResult.accept(.valid)
        case false:     webMailTextValidResult.accept(.notValid)
        }
    }
    
    func tranmitUnivMail() {
        AuthManager.shared.certifyUnivMail(
            univName: univName,
            univEmail: currentWebMail
        )
        .subscribe(
            with: self,
            onSuccess: { owner, _ in
                owner.showAuthCodeView.accept(true)
            },
            onFailure: { owner, error in
                owner.errorHandler.accept(error)
            }
        )
        .disposed(by: disposeBag)
    }
    
    func certifyUnivEmailCode(code: Int) {
        AuthManager.shared.certifyUnivMailCode(
            code: code,
            univName: univName,
            univEmail: currentWebMail
        )
        .subscribe(
            with: self,
            onSuccess: { owner, _ in
                owner.completeEmailCertify.accept(true)
                owner.updateSchoolAuth?.accept(owner.univName)
            },
            onFailure: { owner, error in
                owner.errorHandler.accept(error)
            }
        )
        .disposed(by: disposeBag)
    }
    
    func transmitSchoolCar(image: UIImage) {
        AuthManager.shared.certifySchoolCard1(univ: univName)
            .subscribe(
                with: self,
                onSuccess: { owner, id in
                    
                    AuthManager.shared.certifySchoolCard2(id: id, image: image)
                        .subscribe(
                            onSuccess: { _ in
                                owner.completeSchoolCardCertify.accept(true)
                            },
                            onFailure: { error in
                                owner.errorHandler.accept(error)
                            }
                        )
                        .disposed(by: owner.disposeBag)
                    
                },
                onFailure: { owner, error in
                    owner.errorHandler.accept(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    
    var webMailTextValidResult: BehaviorRelay<WebMailTextValidResult> = .init(value: .notValid)
    
    var showAuthCodeView: PublishRelay<Bool> = .init()
    var completeEmailCertify: PublishRelay<Bool> = .init()
    var completeSchoolCardCertify: PublishRelay<Bool> = .init()
    
    var errorHandler: PublishRelay<Error> = .init()
    
}

enum WebMailTextValidResult {
    case empty
    case valid
    case notValid
    case authComplete
    
    var info: String {
        switch self {
        case .empty, .valid:    return ""
        case .notValid:         return "올바른 형식의 메일을 입력하세요."
        case .authComplete:     return "인증메일이 전송되었습니다."
        }
    }
    
    var color: UIColor? {
        switch self {
        case .empty, .valid:    return nil
        case .notValid:         return CustomColor.red
        case .authComplete:     return CustomColor.purple
        }
    }
}
