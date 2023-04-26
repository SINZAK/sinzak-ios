//
//  SZVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit
import RxSwift

class SZVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configure()
        view.backgroundColor = CustomColor.background
    }
    /// 네비게이션 바 설정.
    func setNavigationBar() {
        // 색상 설정
        navigationController?.navigationBar.tintColor = CustomColor.label
        // 루트뷰가 아닐 경우 백버튼
        if self != navigationController?.viewControllers.first {
            let customBackButton = UIBarButtonItem(
                image: UIImage(named: "back")?.withTintColor(CustomColor.label ?? .label, renderingMode: .alwaysOriginal),
                style: .plain,
                target: self,
                action: #selector(backButtonTapped) )
            navigationItem.leftBarButtonItem = customBackButton
            
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    @objc
    func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    /// VC에서 실행할 메서드
    func configure() {
    }
    let disposeBag = DisposeBag()
}

extension SZVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
