//
//  AgreementVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import RxSwift

final class AgreementVC: SZVC {
    // MARK: - Properties
    let mainView = AgreementView()
    let disposeBag = DisposeBag()
    var viewModel = SignupViewModel()
    var fourteenSelected = false
    var privacySelected = false
    var termsSelected = false
    var marketingSelected = false
    var fullcheck = true
    var requiredSelected = BehaviorSubject(value: false)
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    // MARK: - Actions
    @objc func termsOfServiceButtonTapped(_ sender: UIButton) {
        let vc = WebVC()
        vc.destinationURL = "https://massive-mint-a61.notion.site/bfd66407b0ca4d428a8214165627c191"
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func privacyPolicyButtonTapped(_ sender: UIButton) {
        let vc = WebVC()
        vc.destinationURL = "https://massive-mint-a61.notion.site/cd0047fcc1d1451aa0375eae9b60f5b4"
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func marketingInfoButtonTapped(_ sender: UIButton) {
        let vc = WebVC()
        vc.destinationURL = "https://massive-mint-a61.notion.site/cb0fde6cb51347719f9d100e8e5aba68"
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.termsOfServiceMoreButton.addTarget(self, action: #selector(termsOfServiceButtonTapped), for: .touchUpInside)
        mainView.privacyPolicyMoreButton.addTarget(self, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
        mainView.marketingInfoMoreButton.addTarget(self, action: #selector(marketingInfoButtonTapped), for: .touchUpInside)
    }
    func bind() {
        mainView.fullCheckButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.fullcheck.toggle()
                vc.requiredSelected.onNext(vc.fullcheck)
                vc.mainView.fullCheckButton.isSelected = vc.fullcheck
                vc.mainView.olderFourteenCheckButton.isSelected = vc.fullcheck
                vc.mainView.termsOfServiceCheckButton.isSelected =  vc.fullcheck
                vc.mainView.privacyPolicyCheckButton.isSelected =  vc.fullcheck
                vc.mainView.marketingInfoCheckButton.isSelected =  vc.fullcheck
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.olderFourteenCheckButton
            .rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.fourteenSelected.toggle()
                vc.requiredSelected.onNext(vc.fourteenSelected && vc.termsSelected && vc.privacySelected)
                vc.mainView.olderFourteenCheckButton.isSelected = vc.fourteenSelected
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.termsOfServiceCheckButton
            .rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.termsSelected.toggle()
                vc.requiredSelected.onNext(vc.fourteenSelected && vc.termsSelected && vc.privacySelected)
                vc.mainView.termsOfServiceCheckButton.isSelected = vc.termsSelected
            }
            .disposed(by: viewModel.disposeBag)

        mainView.marketingInfoCheckButton
            .rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.marketingSelected.toggle()
                vc.viewModel.joinInfo.term = vc.marketingSelected
                vc.mainView.marketingInfoCheckButton.isSelected = vc.marketingSelected

            }
            .disposed(by: viewModel.disposeBag)
        mainView.privacyPolicyCheckButton
            .rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.privacySelected.toggle()
                vc.requiredSelected.onNext(vc.fourteenSelected && vc.termsSelected && vc.privacySelected)
                vc.mainView.privacyPolicyCheckButton.isSelected = vc.privacySelected
            }
            .disposed(by: viewModel.disposeBag)
        
        requiredSelected
            .bind(to: mainView.confirmButton.rx.isEnabled)
            .disposed(by: viewModel.disposeBag)
        
        requiredSelected
            .withUnretained(self)
            .subscribe { (vc, bool) in
                if bool {
                    vc.mainView.confirmButton.backgroundColor = CustomColor.red
                } else {
                    vc.mainView.confirmButton.backgroundColor = CustomColor.gray10
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.confirmButton
            .rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                let nextVC = SignupNameVC()
                nextVC.viewModel = vc.viewModel
                vc.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
}
