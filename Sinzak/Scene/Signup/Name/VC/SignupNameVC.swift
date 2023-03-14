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
    var viewModel = SignupViewModel()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Actions
    @objc
    func nextButtonTapped(_ sender: UIButton) {
        let vc = SignupGenreVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        bind()
    }
    func bind() {
        let input = SignupViewModel.Input(nameText: mainView.nameTextField.rx.text)
        let output = viewModel.transform(input: input)
        // 닉네임 유효성 검사
        output.nameValidation
            .bind(onNext: {  [unowned self] bool in
                // 텍스트
                let color: UIColor = bool  ? CustomColor.red! : CustomColor.purple!
                let text: String = bool ? "멋진 이름이네요" : "사용불가능한 이름입니다."
                self.mainView.nameValidationLabel.textColor = color
                self.mainView.nameValidationLabel.text = text
                // 버튼
                let btnColor: UIColor = bool ? CustomColor.red! : CustomColor.gray60!
                self.mainView.checkButton.isEnabled = bool
                self.mainView.checkButton.setTitleColor(btnColor, for: .normal)
                self.mainView.checkButton.layer.borderColor = btnColor.cgColor
            })
            .disposed(by: viewModel.disposeBag)
        // 키보드 자동 설정
        RxKeyboard.instance.visibleHeight
            .drive(with: self, onNext: { (vc, keyboardHeight) in
             print("keyBoard 높이는 \(keyboardHeight) 입니다.")
             if keyboardHeight > 0 {
                 vc.mainView.nextButton.snp.updateConstraints({ make in
                     make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(-keyboardHeight + self.mainView.safeAreaInsets.bottom)
                     make.leading.trailing.equalTo(self.mainView)
                     vc.mainView.nextButton.layer.cornerRadius = 0
                     vc.mainView.layoutIfNeeded()
                 })
             } else {
                 vc.mainView.nextButton.snp.updateConstraints({ make in
                     make.bottom.equalTo(self.mainView.safeAreaLayoutGuide)
                     make.leading.trailing.equalTo(self.mainView).inset(7.4)
                     vc.mainView.nextButton.layer.cornerRadius = 30
                     vc.mainView.layoutIfNeeded()
                 })
             }
         })
         .disposed(by: viewModel.disposeBag)
    }
}
