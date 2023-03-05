//
//  UniversityInfoVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

final class UniversityInfoVC: SZVC {
    // MARK: - Properties
    private let mainView = UniversityInfoView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Actions
    @objc func notStudentButtonTapped(_ sender: UIButton) {
        let vc = WelcomeVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @objc func nextButtonTapped(_ sender: UIButton) {
        let vc = SZVC()  // studentauthvc로 이동
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.notStudentButton.addTarget(self, action: #selector(notStudentButtonTapped), for: .touchUpInside)
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
    }
}
