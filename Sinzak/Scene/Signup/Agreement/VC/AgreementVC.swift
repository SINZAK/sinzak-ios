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
    var viewModel: AgreementVM
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - init
    
    init(viewModel: AgreementVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    override func configure() {
        bind()
    }
    
    // MARK: - Bind
    func bind() {
        bindInput()
        bindOutput()
    }
    
    // MARK: - Bind Input
    func bindInput() {
        // MARK: - 약관 웹뷰로 연결
        mainView.termsOfServiceMoreButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.termsOfServiceMoreButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.privacyPolicyMoreButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.privacyPolicyMoreButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.marketingInfoMoreButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.marketingInfoMoreButtonTapped()
            })
            .disposed(by: disposeBag)
        
        // MARK: - 체크 버튼
        mainView.fullCheckButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.fullCheckbuttonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.olderFourteenCheckButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.olderFourteenCheckButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.termsOfServiceCheckButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.termsOfServiceCheckButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.privacyPolicyCheckButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.privacyPolicyCheckButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.marketingInfoCheckButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.marketingInfoCheckButtonTapped()
            })
            .disposed(by: disposeBag)
        
        // MARK: - 다음 버튼
        mainView.confirmButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.confirmButtonTapped()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - bind Output
    func bindOutput() {
        viewModel.presentWebView
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, webVC in
                webVC.modalPresentationStyle = .pageSheet
                owner.present(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // MARK: - 체크 버튼
        viewModel.isFullCheckbuttonChecked
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.fullCheckButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isOlderFourteenCheckButtonChecked
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.olderFourteenCheckButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isTermsOfServiceCheckButtonChecked
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.termsOfServiceCheckButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isPrivacyPolicyCheckButtonChecked
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.privacyPolicyCheckButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.isMarketingInfoCheckButtonChecked
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.marketingInfoCheckButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            viewModel.isOlderFourteenCheckButtonChecked,
            viewModel.isTermsOfServiceCheckButtonChecked,
            viewModel.isPrivacyPolicyCheckButtonChecked,
            viewModel.isMarketingInfoCheckButtonChecked
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] older, service, privacy, marketing in
            guard let self = self else { return }
            if !(older && service && privacy && marketing) {
                self.viewModel.isFullCheckbuttonChecked.accept(false)
            }
            
            if older && service && privacy {
                self.mainView.confirmButton.isEnabled = true
            } else {
                self.mainView.confirmButton.isEnabled = false
            }
            
            if older && service && privacy && marketing {
                self.mainView.fullCheckButton.isSelected = true
            } else {
                self.mainView.fullCheckButton.isSelected = false
            }
        })
        .disposed(by: disposeBag)
        
        viewModel.pushNameVC
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
// TODO: 마케팅 정보 수신동의 처리
// TODO: 만 14세 이상 확인?
