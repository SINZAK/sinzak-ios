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
    
    var isFullCheckbuttonChecked: BehaviorRelay<Bool> { get }
    var isOlderFourteenCheckButtonChecked: BehaviorRelay<Bool> { get }
    var isTermsOfServiceCheckButtonChecked: BehaviorRelay<Bool> { get }
    var isPrivacyPolicyCheckButtonChecked: BehaviorRelay<Bool> { get }
    var isMarketingInfoCheckButtonChecked: BehaviorRelay<Bool> { get }
    
    var pushNameVC: PublishRelay<ValidateNameVC> { get }
}

protocol AgreementVM: AgreementVMInput, AgreementVMOutput {}

final class DefaultAgreementVM: AgreementVM {
    
    private let disposeBag = DisposeBag()
    
    private var onboardingUser: OnboardingUser
    
    init(onboardingUser: OnboardingUser) {
        self.onboardingUser = onboardingUser
    }
        
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
        if !isFullCheckbuttonChecked.value {
            [
                isOlderFourteenCheckButtonChecked,
                isTermsOfServiceCheckButtonChecked,
                isPrivacyPolicyCheckButtonChecked,
                isMarketingInfoCheckButtonChecked
            ].forEach { $0.accept(true) }
        }
        isFullCheckbuttonChecked.accept(!isFullCheckbuttonChecked.value)
    }
    
    func olderFourteenCheckButtonTapped() {
        isOlderFourteenCheckButtonChecked
            .accept(!isOlderFourteenCheckButtonChecked.value)
    }
    
    func termsOfServiceCheckButtonTapped() {
        isTermsOfServiceCheckButtonChecked
            .accept(!isTermsOfServiceCheckButtonChecked.value)
    }
    
    func privacyPolicyCheckButtonTapped() {
        isPrivacyPolicyCheckButtonChecked
            .accept(!isPrivacyPolicyCheckButtonChecked.value)
    }
     
    func marketingInfoCheckButtonTapped() {
        isMarketingInfoCheckButtonChecked
            .accept(!isMarketingInfoCheckButtonChecked.value)
    }
    
    func confirmButtonTapped() {
        onboardingUser.term = isMarketingInfoCheckButtonChecked.value
        let vm = DefaultValidateNameVM(onboardingUser: onboardingUser)
        let vc = ValidateNameVC(validateNameViewControllerType: .signup, viewModel: vm)
        pushNameVC.accept(vc)
    }
    
    // MARK: - Output
    
    var presentWebView: PublishRelay<WebVC> = .init()
    
    var isFullCheckbuttonChecked: BehaviorRelay<Bool> = .init(value: false)
    var isOlderFourteenCheckButtonChecked: BehaviorRelay<Bool> = .init(value: false)
    var isTermsOfServiceCheckButtonChecked: BehaviorRelay<Bool> = .init(value: false)
    var isPrivacyPolicyCheckButtonChecked: BehaviorRelay<Bool> = .init(value: false)
    var isMarketingInfoCheckButtonChecked: BehaviorRelay<Bool> = .init(value: false)
    
    var pushNameVC: PublishRelay<ValidateNameVC> = .init()
}
