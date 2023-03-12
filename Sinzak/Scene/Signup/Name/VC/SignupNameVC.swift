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
        RxKeyboard.instance.visibleHeight
         .drive(onNext: { [unowned self] keyboardHeight in
             print("keyBoard 높이는 \(keyboardHeight) 입니다.")
             if keyboardHeight > 0 {
                 self.mainView.nextButton.snp.updateConstraints({ make in
                     make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(-keyboardHeight + self.mainView.safeAreaInsets.bottom)
                     make.leading.trailing.equalTo(self.mainView)
                     self.mainView.nextButton.layer.cornerRadius = 0
                     self.mainView.layoutIfNeeded()
                 })
             } else {
                 self.mainView.nextButton.snp.updateConstraints({ make in
                     make.bottom.equalTo(self.mainView.safeAreaLayoutGuide)
                     make.leading.trailing.equalTo(self.mainView).inset(7.4)
                     self.mainView.nextButton.layer.cornerRadius = 30
                     self.mainView.layoutIfNeeded()
                 })
             }
         })
         .disposed(by: viewModel.disposeBag)
    }
}
