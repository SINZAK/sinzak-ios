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
        let logotype = UIBarButtonItem(image: UIImage(named: "logotype-right"),
                                       style: .plain,
                                       target: self,
                                       action: nil)
        let notification = UIBarButtonItem(image: UIImage(named: "notification"),
                                           style: .plain,
                                           target: self,
                                           action: nil )
        navigationItem.leftBarButtonItem = logotype
        navigationItem.rightBarButtonItem = notification
    }
    
    override func configure() {
        
    }
}
