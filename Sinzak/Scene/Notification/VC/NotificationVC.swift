//
//  NotificationVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit

final class NotificationVC: SZVC {
    // MARK: - Properties
    //let mainView = HomeDetailView()
    // MARK: - Lifecycle
    //override func loadView() {
    //    view = mainView
    //}
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "알림"
    }
}
