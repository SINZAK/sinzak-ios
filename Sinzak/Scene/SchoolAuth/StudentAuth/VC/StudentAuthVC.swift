//
//  StudentAuthVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

final class StudentAuthVC: SZVC {
    // MARK: - Properties
    private let mainView = StudentAuthView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Helpers
    override func configure() {
        
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.schoolAuth
    }
}
