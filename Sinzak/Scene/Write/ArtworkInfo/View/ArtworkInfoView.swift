//
//  ArtworkInfoView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class ArtworkInfoView: SZView {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.gray80
        $0.text = " · " + I18NStrings.artworkTitle
    }
    let titleTextField = SZTextField().then {
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 30
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.clearButtonMode = .whileEditing
    }
    private let priceLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.gray80
        $0.text = " · " + I18NStrings.price
    }
    let priceTextField = SZTextField().then {
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 22
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.clearButtonMode = .whileEditing
    }
    private let krwLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.gray80
        $0.text = I18NStrings.krw
    }
    let priceOfferToggleButton = UIButton().then {
        $0.tintColor = CustomColor.black
        $0.setImage(UIImage(named: "check-circle-pressed"), for: .normal)
        $0.setTitle(I18NStrings.getPriceOffer, for: .normal)
        $0.setTitleColor(CustomColor.black, for: .normal)
    }
    private let artworkDescriptionLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.gray80
        $0.text = " · " + I18NStrings.artworkDescription
    }
    let artworkDescriptionTextView = UITextView().then {
        $0.text = I18NStrings.artworkDescriptionPlaceholder
        $0.backgroundColor = CustomColor.gray10
        $0.contentInset = .init(top: 20, left: 35, bottom: 20, right: 22)
        $0.layer.cornerRadius = 30
        $0.tintColor = CustomColor.red
        $0.font = .body_R
        $0.textColor = CustomColor.black
    }
    let nextButton = UIButton().then {
        $0.setTitle(I18NStrings.next, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.layer.cornerRadius = 33
        $0.backgroundColor = CustomColor.red
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            titleLabel,
            titleTextField,
            priceLabel,
            priceTextField,
            krwLabel,
            priceOfferToggleButton,
            artworkDescriptionLabel,
            artworkDescriptionTextView,
            nextButton
        )
    }
    override func setLayout() {

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleTextField.snp.bottom).offset(19)
        }
        priceTextField.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel)
            make.top.equalTo(priceLabel.snp.bottom).offset(14)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(45)
        }
        krwLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceTextField)
            make.leading.equalTo(priceTextField.snp.trailing).offset(14)
        }
        priceOfferToggleButton.snp.makeConstraints { make in
            make.height.centerY.equalTo(priceTextField)
            make.leading.equalTo(krwLabel.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(32)
        }
        artworkDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(priceTextField.snp.bottom).offset(19)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(65)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        artworkDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(artworkDescriptionLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-28)
        }
    }
}
