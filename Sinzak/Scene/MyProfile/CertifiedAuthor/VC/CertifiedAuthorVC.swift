//
//  CertifiedAuthorVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/06.
//

import UIKit

final class CertifiedAuthorVC: SZVC {
    // MARK: - Properties
    private let mainView = CertifiedAuthorView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Actions
    @objc func schoolAuthButtonTapped(_ sender: UIButton) {
        // 웰컴뷰 없애야함
    }
    @objc func applyButtonTapped(_ sender: UIButton) {
        // 신청
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.schoolAuthButton.addTarget(self, action: #selector(schoolAuthButtonTapped), for: .touchUpInside)
        mainView.applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        
        navigationItem.title = I18NStrings.certifiedAuthorApplication
    }
}
