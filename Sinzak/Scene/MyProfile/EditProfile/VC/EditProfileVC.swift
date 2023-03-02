//
//  EditProfileVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/02.
//

import UIKit

final class EditProfileVC: SZVC {
    // MARK: - Properties
    private let mainView = EditProfileView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Actions
    @objc func finishButtonTapped(_ sender: UIBarButtonItem) {
        // - 수정내용 저장하는 로직
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        
        let finish = UIBarButtonItem(title: I18NStrings.finish, style: .plain, target: self, action: #selector(finishButtonTapped))
        navigationItem.rightBarButtonItem = finish
    }
}
