//
//  CertifiedAuthorVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/06.
//

import UIKit

final class CertifiedAuthorVC: SZVC {
    // MARK: - Properties
    private let mainView = CertifiedAuthorView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MAKR: - Helpers
    override func configure() {
        
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        
        navigationItem.title = I18NStrings.certifiedAuthorApplication
    }
}
