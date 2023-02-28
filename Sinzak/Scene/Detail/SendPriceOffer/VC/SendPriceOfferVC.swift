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
    // MARK: - Helpers
    override func configure() {
        
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.sendPriceOffer
    }
}
