//
//  ConciergeVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit

final class ConciergeVC: UIViewController {
    let mainView = ConciergeView()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        concierge()
        view.backgroundColor = CustomColor.background
    }
    func concierge() {
        mainView.logoView.play { _ in
            // TODO: 네트워크 상태와 자동로그인 여부 확인하여 분기
//            let root = LoginVC(viewModel: DefaultLoginVM())
//            let vc = UINavigationController(rootViewController: root)
            let vc = TabBarVC()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: false)
        }
    }
}
