//
//  SignupNameView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

import Then
import SnapKit

final class SignupNameView: SZView {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = I18NStrings.pleaseEnterName
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.numberOfLines = 0
    }
    private let descriptionLabel = UILabel().then {
        $0.text = I18NStrings.nameValidationDescription
        $0.font = .body_R
        $0.textColor = CustomColor.gray60
        $0.numberOfLines = 0
    }
    let nameTextField = SZTextField().then {
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 30
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.clearButtonMode = .whileEditing
    }
    let checkButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(CustomColor.red, for: .normal)
        $0.titleLabel?.font = .caption_B
        $0.layer.borderColor = CustomColor.red!.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 19
    }
    // 다음 버튼
    let nextButton = UIButton().then {
        $0.setTitle(I18NStrings.next, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 30
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            titleLabel, descriptionLabel, nameTextField, nextButton, checkButton
        )
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(15.87)
            make.leading.equalToSuperview().inset(32.58)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8.21)
        }
        checkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(37)
            make.width.equalTo(86)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
        }
        nameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(checkButton.snp.leading).offset(-11)
            make.height.equalTo(60)
            make.centerY.equalTo(checkButton)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(7.4)
            make.height.equalTo(65)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
