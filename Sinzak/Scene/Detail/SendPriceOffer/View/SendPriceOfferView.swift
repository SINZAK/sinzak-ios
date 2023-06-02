//
//  SendPriceOfferView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import UIKit
import SnapKit
import Then

final class SendPriceOfferView: SZView {
    // MARK: - Properties
    private let pleaseOfferLabel = UILabel().then {
        $0.text = "시세에 맞는 가격을 제안해보세요."
        $0.font = .body_B
        $0.textColor = CustomColor.label
    }
    private let currentBestPriceLabel = UILabel().then {
        $0.text = "현재 최고 금액"
        $0.font = .body_B
        $0.textColor = CustomColor.label
    }
    let priceLabel = UILabel().then {
        $0.text = "50,000"
        $0.font = .body_B
        $0.textColor = CustomColor.purple
    }
    private let wonLabel = UILabel().then {
        $0.text = "원"
        $0.font = .body_B
        $0.textColor = CustomColor.label
    }
    let priceTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).then {
        $0.keyboardType = .numberPad
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = .subtitle_B
        $0.textColor = CustomColor.label
    }
    private let wonBiggerLabel = UILabel().then {
        $0.text = "원"
        $0.font = .subtitle_B
        $0.textColor = CustomColor.gray80
    }
    private let warningLabel =  UILabel().then {
        
        $0.textColor = CustomColor.label
        let text = "게시글 당 1회만 제안이 가능해요"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .foregroundColor,
            value: CustomColor.red,
            range: (text as NSString).range(of: "1회")
        )
        $0.attributedText = attributedString
        $0.font = .caption_M
    }
    let suggestButton = SZButton().then {
        $0.setTitle("제안하기", for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.backgroundColor = CustomColor.red
        $0.titleLabel?.font = .body_B
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            pleaseOfferLabel,
            currentBestPriceLabel,
            priceLabel,
            wonLabel,
            priceTextField,
            wonBiggerLabel,
            warningLabel,
            suggestButton
        )
    }
    override func setLayout() {
        pleaseOfferLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
        }
        currentBestPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(pleaseOfferLabel)
            make.top.equalTo(pleaseOfferLabel.snp.bottom).offset(12)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(currentBestPriceLabel.snp.trailing).offset(5)
            make.centerY.equalTo(currentBestPriceLabel)
        }
        wonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.leading.equalTo(priceLabel.snp.trailing).offset(3)
        }
        priceTextField.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview().offset(-12)
            make.top.equalTo(currentBestPriceLabel.snp.bottom).offset(24)
        }
        wonBiggerLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceTextField.snp.trailing).offset(10)
            make.centerY.equalTo(priceTextField)
        }
        warningLabel.snp.makeConstraints { make in
            make.centerX.equalTo(priceTextField)
            make.top.equalTo(priceTextField.snp.bottom).offset(8)
        }
        suggestButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(65)
            make.bottom.equalToSuperview().inset(24.0)
        }
    }
}
