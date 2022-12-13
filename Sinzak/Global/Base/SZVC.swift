//
//  SZVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit

class SZVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configure()
    }
    /// 네비게이션 바 설정.
    func setNavigationBar() {
        // 색상 설정
        navigationController?.navigationBar.tintColor = CustomColor.black
        // 루트뷰가 아닐 경우 백버튼
        if self != navigationController?.viewControllers.first {
            let customBackButton = UIBarButtonItem(
                image: UIImage(named: "back"),
                style: .plain,
                target: self,
                action: #selector(backButtonTapped) )
            navigationItem.leftBarButtonItem = customBackButton
        }
    }
    @objc
    func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    /// VC에서 실행할 메서드
    func configure() {
    }
}
