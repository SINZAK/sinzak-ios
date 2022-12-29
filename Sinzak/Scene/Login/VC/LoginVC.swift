//
//  LoginVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/26.
//

import UIKit

final class LoginVC: SZVC {
    // MARK: - Properties
    let mainView = LoginView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc
    func kakaoButtonTapped(_ sender: UIButton) {
        // 로그인 / 회원가입 분기
        let vc = AgreementVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helpers
    override func configure() {
        mainView.kakaoButton.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
    }
}
