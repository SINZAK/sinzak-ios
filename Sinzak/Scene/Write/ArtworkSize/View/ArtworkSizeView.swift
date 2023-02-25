//
//  ArtworkSizeView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/25.
//

import UIKit
import SnapKit
import Then

final class ArtworkSizeView: SZView {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.gray80
        $0.text = " · " + I18NStrings.pleaseApproxSizeOfArtwork
    }
    private let widthLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.gray80
        $0.text = I18NStrings.width
    }
    private let heightLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.gray80
        $0.text = I18NStrings.height
    }
    private let depthLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.gray80
        $0.text = I18NStrings.depth
    }
    private let mLabel01 = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.gray80
        $0.text = "m"
    }
    private let cmLabel01 = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.gray80
        $0.text = "cm"
    }
    private let mLabel02 = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.gray80
        $0.text = "m"
    }
    private let cmLabel02 = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.gray80
        $0.text = "cm"
    }
    private let mLabel03 = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.gray80
        $0.text = "m"
    }
    private let cmLabel03 = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.gray80
        $0.text = "cm"
    }
    let widthMeterTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)).then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.layer.cornerRadius = 30
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    let widthCentimeterTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)).then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.layer.cornerRadius = 30
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    let heightMeterTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)).then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.layer.cornerRadius = 30
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    let heightCentimeterTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)).then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.layer.cornerRadius = 30
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    let depthMeterTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)).then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.layer.cornerRadius = 30
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    let depthCentimeterTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)).then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.layer.cornerRadius = 30
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    let finishButton = UIButton().then {
        $0.setTitle(I18NStrings.finish, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.layer.cornerRadius = 33
        $0.backgroundColor = CustomColor.red
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            titleLabel,
            widthLabel, heightLabel, depthLabel,
            mLabel01, mLabel02, mLabel03,
            cmLabel01, cmLabel02, cmLabel03,
            widthMeterTextField, heightMeterTextField, depthMeterTextField,
            widthCentimeterTextField, heightCentimeterTextField, depthCentimeterTextField,
            finishButton
        )
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
        }
        heightLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
        }
        heightMeterTextField.snp.makeConstraints { make in
            make.leading.equalTo(heightLabel.snp.trailing).offset(10)
            make.centerY.equalTo(heightLabel)
            make.width.equalToSuperview().multipliedBy(0.23)
            make.height.equalTo(60)
        }
        widthMeterTextField.snp.makeConstraints { make in
            make.bottom.equalTo(heightMeterTextField.snp.top).offset(-24)
            make.leading.width.height.equalTo(heightMeterTextField)
        }
        depthMeterTextField.snp.makeConstraints { make in
            make.top.equalTo(heightMeterTextField.snp.bottom).offset(24)
            make.leading.width.height.equalTo(heightMeterTextField)
        }
        widthLabel.snp.makeConstraints { make in
            make.leading.equalTo(heightLabel)
            make.centerY.equalTo(widthMeterTextField)
        }
        depthLabel.snp.makeConstraints { make in
            make.leading.equalTo(heightLabel)
            make.centerY.equalTo(depthMeterTextField)
        }
        mLabel02.snp.makeConstraints { make in
            make.centerY.equalTo(heightLabel)
            make.leading.equalTo(heightMeterTextField.snp.trailing).offset(6)
        }
        cmLabel02.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.centerY.equalTo(heightLabel)
        }
        heightCentimeterTextField.snp.makeConstraints { make in
            make.height.centerY.equalTo(heightMeterTextField)
            make.width.greaterThanOrEqualToSuperview().multipliedBy(0.3)
            make.leading.equalTo(mLabel02.snp.trailing).offset(14)
            make.trailing.equalTo(cmLabel02.snp.leading).offset(-8)
        }
        mLabel01.snp.makeConstraints { make in
            make.centerY.equalTo(widthLabel)
            make.leading.equalTo(mLabel02)
        }
        mLabel03.snp.makeConstraints { make in
            make.centerY.equalTo(depthLabel)
            make.leading.equalTo(mLabel02)
        }
        cmLabel01.snp.makeConstraints { make in
            make.centerY.equalTo(widthLabel)
            make.leading.equalTo(cmLabel02)
        }
        cmLabel03.snp.makeConstraints { make in
            make.centerY.equalTo(depthLabel)
            make.leading.equalTo(cmLabel02)
        }
        widthCentimeterTextField.snp.makeConstraints { make in
            make.height.centerY.equalTo(widthMeterTextField)
            make.width.greaterThanOrEqualTo(widthMeterTextField)
            make.leading.trailing.equalTo(heightCentimeterTextField)
        }
        depthCentimeterTextField.snp.makeConstraints { make in
            make.height.centerY.equalTo(depthMeterTextField)
            make.width.greaterThanOrEqualTo(depthMeterTextField)
            make.leading.trailing.equalTo(heightCentimeterTextField)
        }
        finishButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(65)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }

    }
}
