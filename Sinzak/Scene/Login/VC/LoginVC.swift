//
//  LoginVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/26.
//

import UIKit

final class LoginVC: SZVC {
    // MARK: - Properties
    let mainView = LoginView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
}
