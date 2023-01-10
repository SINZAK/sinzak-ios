//
//  HomeVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/10.
//

import UIKit

final class HomeVC: SZVC {
    // MARK: - Properties
    let mainView = HomeView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    override func setNavigationBar() {
        
    }
    
    override func configure() {
        
    }
}
