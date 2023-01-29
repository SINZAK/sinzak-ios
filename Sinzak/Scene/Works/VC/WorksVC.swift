//
//  WorksVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/29.
//

import UIKit

final class WorksVC: SZVC {
    // MARK: - Properties
    let mainView = WorksView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
