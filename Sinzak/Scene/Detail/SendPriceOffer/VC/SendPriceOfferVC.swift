//
//  SendPriceOfferVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import UIKit

final class SendPriceOfferVC: SZVC {
    // MARK: - Properties
    let mainView = SendPriceOfferView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    // MARK: - Actions
    /// 가격 제안하는 메서드
    @objc func suggestPriceOffer(_ sender: UIButton) {
        // 제안 요청
        // 얼럿 띄워서 확인하기
        // 토스트 띄우기
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.suggestButton.addTarget(self, action: #selector(suggestPriceOffer), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.sendPriceOffer
    }
}
