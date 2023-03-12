//
//  SignupNameVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

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
    }
}
