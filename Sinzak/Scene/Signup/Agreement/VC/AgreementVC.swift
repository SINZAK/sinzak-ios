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
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
        
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        mainView.termsOfServiceMoreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.termsOfServiceButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.privacyPolicyMoreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.privacyPolicyButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.marketingInfoMoreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.marketingInfoButtonTapped()
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        viewModel.presentWebView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] webVC in
                webVC.modalPresentationStyle = .pageSheet
                self?.present(webVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
