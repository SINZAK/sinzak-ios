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
        view.backgroundColor = CustomColor.background
        concierge()
    }
    
    func concierge() {
        // 애니메이션, 로그인(1. 로그인화면, 2. 탭화면), 정보 저장
        
        if KeychainItem.isLoggedIn {
            
        }
        
        // 애니메이션
        mainView.logoView.play { _ in
            // TODO: 네트워크 상태와 자동로그인 여부 확인하여 분기
//            let root = LoginVC(viewModel: DefaultLoginVM())
//            let vc = UINavigationController(rootViewController: root)
//            let vc = TabBarVC()
            
            let vc: UIViewController
            if KeychainItem.isLoggedIn {
                vc = TabBarVC()
            } else {
                let root = LoginVC(viewModel: DefaultLoginVM())
                vc = UINavigationController(rootViewController: root)
            }
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: false)
        }
    }
}
