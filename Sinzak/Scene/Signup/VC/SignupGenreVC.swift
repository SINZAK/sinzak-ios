//
//  SignupGenreVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

final class SignupGenreVC: SZVC {
    // MARK: - Properties
    let mainView = SignupGenreView()
    
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


