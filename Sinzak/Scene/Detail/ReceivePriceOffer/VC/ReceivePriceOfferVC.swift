//
//  ReceivePriceOfferVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import UIKit

final class ReceivePriceOfferVC: SZVC {
    // MARK: - Properties
    let mainView = ReceivePriceOfferView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    // MARK: - Actions
    /// 가격제안 수락
    @objc func acceptOffer(_ sender: UIButton) {
        // 수락 요청 - toaster 필요
        navigationController?.popViewController(animated: true)
    }
    /// 가격제안 거절
    @objc func declineOffer(_ sender: UIButton) {
        // 거절 요청 - toast 필요
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.acceptButton.addTarget(self, action: #selector(acceptOffer), for: .touchUpInside)
        mainView.declineButton.addTarget(self, action: #selector(declineOffer), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.priceOffer
    }
}
