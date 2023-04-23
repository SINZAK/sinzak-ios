//
//  WelcomeVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import UIKit

final class WelcomeVC: SZVC {
    // MARK: - Properties
    private let mainView = WelcomeView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    // MARK: - Actions
    @objc func letsGoButtonTapped(_ sender: UIButton) {
        let vc = TabBarVC()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: false)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.confettiView.startConfetti()
        mainView.letsGoButton.addTarget(self, action: #selector(letsGoButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
}
