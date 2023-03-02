//
//  SettingVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/02.
//

import UIKit

final class SettingVC: SZVC {
    // MARK: - Properties
    private let mainView = SettingView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Helpers
    override func configure() {
        
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        
        navigationItem.title = I18NStrings.setting
    }
}
