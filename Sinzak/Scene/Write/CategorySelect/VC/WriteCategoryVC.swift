//
//  WriteCategoryVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit

final class WriteCategoryVC: SZVC {
    // MARK: - Properties
    private let mainView = WriteCategoryView()
    // MARK: - Helpers
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Actions
    // MARK: - Helpers
    override func configure() {
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.categorySelection
    }
}
