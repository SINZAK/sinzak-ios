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
    }
    func concierge() {
        // 네트워크 상태와 자동로그인 여부 확인하여 분기
    }
}
