//
//  ReceivePriceOfferView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import UIKit
import SnapKit
import Then

final class ReceivePriceOfferView: SZView {
    // MARK: - Properties
    let offererNameLabel = UILabel().then {
        $0.text = "김신작"
        $0.font = .body_B
        $0.textColor = CustomColor.black
    }
    private let fromNimLabel = UILabel().then {
        $0.text = " 님께서"
        $0.font = .body_B
        $0.textColor = CustomColor.black
    }
    private let suggestedPriceOfferLael = UILabel().then {
        $0.text = "가격을 제안하셨어요."
        $0.font = .body_B
        $0.textColor = CustomColor.black
    }
    let priceTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).then {
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.isUserInteractionEnabled = false
        $0.text = "50,000"
    }
    private let wonBiggerLabel = UILabel().then {
        $0.text = "원"
        $0.font = .subtitle_B
        $0.textColor = CustomColor.gray80
    }
    let buttonStackView = UIStackView().then {
        $0.spacing = 12
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let declineButton = UIButton().then {
        $0.setTitle("거절하기", for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.backgroundColor = CustomColor.gray40
        $0.titleLabel?.font = .body_B
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    let acceptButton = UIButton().then {
        $0.setTitle("accept", for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.backgroundColor = CustomColor.red
        $0.titleLabel?.font = .body_B
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            offererNameLabel,
            fromNimLabel,
            suggestedPriceOfferLael,
            priceTextField,
            wonBiggerLabel,
            buttonStackView
        )
        buttonStackView.addArrangedSubviews(
            declineButton,
            acceptButton
        )
    }
    override func setLayout() {
        offererNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
        }
        fromNimLabel.snp.makeConstraints { make in
            make.leading.equalTo(offererNameLabel.snp.trailing).offset(3)
            make.centerY.equalTo(offererNameLabel)
        }
        suggestedPriceOfferLael.snp.makeConstraints { make in
            make.leading.equalTo(offererNameLabel)
            make.top.equalTo(offererNameLabel.snp.bottom).offset(6)
        }
        priceTextField.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview().offset(-12)
            make.top.equalTo(suggestedPriceOfferLael.snp.bottom).offset(24)
        }
        wonBiggerLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceTextField.snp.trailing).offset(10)
            make.centerY.equalTo(priceTextField)
        }
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(65)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
}
