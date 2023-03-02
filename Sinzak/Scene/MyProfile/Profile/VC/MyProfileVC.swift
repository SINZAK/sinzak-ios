//
//  MyProfileVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/12.
//

import UIKit

final class MyProfileVC: SZVC {
    // MARK: - Properties
    let mainView = MyProfileView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Actions
    @objc func settingButtonTapped(_ sender: UIBarButtonItem) {
    }
    @objc func profileEditButtonTapped(_ sender: UIButton) {
        let vc = EditProfileVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.profileEditButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        let setting = UIBarButtonItem(image: UIImage(named: "setting"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem = setting
    }
}
