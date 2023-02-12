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
    // MARK: - Actions
    @objc func settingButtonTapped(_ sender: UIBarButtonItem) {
    }
    // MARK: - Helpers
    override func configure() {
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
