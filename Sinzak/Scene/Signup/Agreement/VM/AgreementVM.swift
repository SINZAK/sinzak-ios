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
    func termsOfServiceMoreButtonTapped()
    func privacyPolicyMoreButtonTapped()
    func marketingInfoMoreButtonTapped()
    
    func fullCheckbuttonTapped()
    func olderFourteenCheckButtonTapped()
    func termsOfServiceCheckButtonTapped()
    func privacyPolicyCheckButtonTapped()
    func marketingInfoCheckButtonTapped()
    
    func confirmButtonTapped()
}

protocol AgreementVMOutput {
    var presentWebView: PublishRelay<WebVC> { get }
    
    var isFullCheckbuttonTapped: BehaviorRelay<Bool> { get }
    var isOlderFourteenCheckButtonTapped: BehaviorRelay<Bool> { get }
    var isTermsOfServiceCheckButtonTapped: BehaviorRelay<Bool> { get }
    var isPrivacyPolicyCheckButtonTapped: BehaviorRelay<Bool> { get }
    var isMarketingInfoCheckButtonTapped: BehaviorRelay<Bool> { get }
    
    var pushNameVC: PublishRelay<SignupNameVC> { get }
}

protocol AgreementVM: AgreementVMInput, AgreementVMOutput {}

final class DefaultAgreementVM: AgreementVM {
    
    private let disposeBag = DisposeBag()
        
    // MARK: - Input
    func termsOfServiceMoreButtonTapped() {
        let vc = WebVC()
        vc.destinationURL = "https://sinzak.notion.site/bfd66407b0ca4d428a8214165627c191"
        presentWebView.accept(vc)
    }
    
    func privacyPolicyMoreButtonTapped() {
        let vc = WebVC()
        vc.destinationURL = "https://sinzak.notion.site/cd0047fcc1d1451aa0375eae9b60f5b4"
        presentWebView.accept(vc)
    }
    
    func marketingInfoMoreButtonTapped() {
        let vc = WebVC()
        vc.destinationURL = "https://sinzak.notion.site/cb0fde6cb51347719f9d100e8e5aba68"
        presentWebView.accept(vc)
    }
    
    func fullCheckbuttonTapped() {
        if !isFullCheckbuttonTapped.value {
            [
                isOlderFourteenCheckButtonTapped,
                isTermsOfServiceCheckButtonTapped,
                isPrivacyPolicyCheckButtonTapped,
                isMarketingInfoCheckButtonTapped
            ].forEach { $0.accept(true) }
        }
        isFullCheckbuttonTapped.accept(!isFullCheckbuttonTapped.value)
    }
    
    func olderFourteenCheckButtonTapped() {
        isOlderFourteenCheckButtonTapped
            .accept(!isOlderFourteenCheckButtonTapped.value)
    }
    
    func termsOfServiceCheckButtonTapped() {
        isTermsOfServiceCheckButtonTapped
            .accept(!isTermsOfServiceCheckButtonTapped.value)
    }
    
    func privacyPolicyCheckButtonTapped() {
        isPrivacyPolicyCheckButtonTapped
            .accept(!isPrivacyPolicyCheckButtonTapped.value)
    }
     
    func marketingInfoCheckButtonTapped() {
        isMarketingInfoCheckButtonTapped
            .accept(!isMarketingInfoCheckButtonTapped.value)
    }
    
    func confirmButtonTapped() {
        let vm = DefaultSignupNameVM()
        let vc = SignupNameVC(viewModel: vm)
        pushNameVC.accept(vc)
    }
    
    // MARK: - Output
    
    var presentWebView: PublishRelay<WebVC> = .init()
    
    var isFullCheckbuttonTapped: BehaviorRelay<Bool> = .init(value: false)
    var isOlderFourteenCheckButtonTapped: BehaviorRelay<Bool> = .init(value: false)
    var isTermsOfServiceCheckButtonTapped: BehaviorRelay<Bool> = .init(value: false)
    var isPrivacyPolicyCheckButtonTapped: BehaviorRelay<Bool> = .init(value: false)
    var isMarketingInfoCheckButtonTapped: BehaviorRelay<Bool> = .init(value: false)
    
    var pushNameVC: PublishRelay<SignupNameVC> = .init()
}
