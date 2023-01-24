//
//  MarketVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import Tabman
import Pageboy

final class MarketVC: TabmanViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configure()
    }
    @objc func searchButtonTapped(_ sender: UIBarButtonItem) {
        // 검색화면으로 이동
        let vc = SZVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    func setNavigationBar() {
        navigationController?.navigationBar.tintColor = CustomColor.black
        navigationItem.title = "마켓"
        let search = UIBarButtonItem(
            image: UIImage(named: "search"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = search
    }
    func configure() {
        view.backgroundColor = CustomColor.white
    }
}
