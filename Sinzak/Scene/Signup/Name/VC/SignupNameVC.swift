//
//  SignupNameVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

final class SignupNameVC: SZVC {
    // MARK: - Properties
    let mainView = SignupNameView()
    var viewModel: SignupNameVM
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Init
    
    init(viewModel: SignupNameVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
        
    // MARK: - Helpers
    override func configure() {
        bind()
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        mainView.nameTextField.rx.value
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.nameTextFieldInput(name: text)
            })
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.tapCheckButton()
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeignt in
                guard let self = self else { return }
                if keyboardVisibleHeignt > 0 {
                    self.mainView.nextButton.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(keyboardVisibleHeignt + 16.0)
                    }
                    self.view.layoutIfNeeded()
                    
                } else {
                    self.mainView.nextButton.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(24.0)
                    }
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        viewModel.isValidCheckButton
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.checkButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        let doubleCheckResult = viewModel.doubleCheckResult

        viewModel.doubleCheckResult
            .asDriver(onErrorJustReturn: .beforeCheck)
            .drive(onNext: { [weak self] result in
                switch result {
                case .beforeCheck:
                    self?.mainView.nameValidationLabel.text = ""
                    
                case let .sucess(text, color):
                    self?.mainView.nameValidationLabel.text = text
                    self?.mainView.nameValidationLabel.textColor = color
                    
                case let .fail(text, color):
                    self?.mainView.nameValidationLabel.text = text
                    self?.mainView.nameValidationLabel.textColor = color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.doubleCheckResult
            .asDriver(onErrorJustReturn: .beforeCheck)
            .map {
                
            }
                
//            .drive(onNext: { [weak self] result in
//                switch result {
//                case let .sucess(_, _):
//                    self?.mainView.nextButton.rx
//                }
//            })
    }
}

// TODO: 버튼 처리
