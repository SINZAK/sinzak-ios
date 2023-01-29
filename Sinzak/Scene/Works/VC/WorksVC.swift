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
    // MARK: - Actions
    /// 검색화면으로 이동
    @objc func searchButtonTapped(_ sender: UIBarButtonItem) {
        let vc = SZVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "외주"
        let search = UIBarButtonItem(
            image: UIImage(named: "search"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = search
    }
}
