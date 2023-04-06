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
    func termsOfServiceButtonTapped()
    func privacyPolicyButtonTapped()
    func marketingInfoButtonTapped()
}

protocol AgreementVMOutput {
    var presentWebView: PublishRelay<WebVC> { get }
}

protocol AgreementVM: AgreementVMInput, AgreementVMOutput {}

final class DefaultAgreementVM: AgreementVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    func termsOfServiceButtonTapped() {
        let vc = WebVC()
        Log.debug("tap")
        vc.destinationURL = "https://sinzak.notion.site/bfd66407b0ca4d428a8214165627c191"
        presentWebView.accept(vc)
    }
    
    func privacyPolicyButtonTapped() {
        let vc = WebVC()
        Log.debug("tap")
        vc.destinationURL = "https://sinzak.notion.site/cd0047fcc1d1451aa0375eae9b60f5b4"
        presentWebView.accept(vc)
    }
    
    func marketingInfoButtonTapped() {
        Log.debug("tap")
        let vc = WebVC()
        vc.destinationURL = "https://sinzak.notion.site/cb0fde6cb51347719f9d100e8e5aba68"
        presentWebView.accept(vc)
    }
    
    // MARK: - Output
    
    var presentWebView: PublishRelay<WebVC> = .init()
}
