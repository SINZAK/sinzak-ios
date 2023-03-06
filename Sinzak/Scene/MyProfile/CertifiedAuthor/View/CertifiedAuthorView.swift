//
//  CertifiedAuthorView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/06.
//

import UIKit
import SnapKit
import Then

final class CertifiedAuthorView: SZView {
    // MARK: - Properties
    private let sinzakAuthorLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.sinzakCertifiedAuthor
    }
    private let descriptionLabel01 = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.sinzakCertifiedAuthorDescription01
    }
    private let badgeImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "verified-badge")
    }
    private let descriptionLabel02 = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.sinzakCertifiedAuthorDescription02
    }
    private let descriptionLabel03 = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.sinzakCertifiedAuthorDescription03
    }
    // 1단계
    private let firstStepLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.firstStepSchoolAuth
    }
    private let schoolLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.school
        $0.setContentHuggingPriority(.init(rawValue: 999), for: .horizontal)
    }
    let schoolNameLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.black
        $0.text = "신작대학교"
        $0.textAlignment = .center
    }
    let schoolAuthButton = UIButton().then {
        $0.setTitle(I18NStrings.verify, for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.titleLabel?.font = .body_M
    }
    // 2단계
    private let secondStepLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.secondStepPortfolioLink
    }
    private let secondStepDescriptionLabel = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.secondStepPortfolioLinkDescription
        $0.addInterlineSpacing(spacing: 3)
        $0.numberOfLines = 0
    }
    let portfolioLinkTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).then {
        $0.placeholder = I18NStrings.pleaseEnterLink
        $0.font = .caption_R
        $0.textColor = CustomColor.black
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
    }
    let applyButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
        $0.setTitle(I18NStrings.apply, for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.backgroundColor = CustomColor.red
        $0.titleLabel?.font = .body_B
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            sinzakAuthorLabel,
            descriptionLabel01,
            badgeImage,
            descriptionLabel02,
            descriptionLabel03,
            firstStepLabel,
            schoolLabel,
            schoolNameLabel,
            schoolAuthButton,
            secondStepLabel,
            secondStepDescriptionLabel,
            portfolioLinkTextField,
            applyButton
        )
    }
    override func setLayout() {
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(65)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        sinzakAuthorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.equalTo(safeAreaLayoutGuide).inset(25)
        }
        descriptionLabel01.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(34)
            make.top.equalTo(sinzakAuthorLabel.snp.bottom).offset(12)
        }
        badgeImage.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalTo(descriptionLabel01.snp.trailing)
            make.centerY.equalTo(descriptionLabel01)
        }
        descriptionLabel02.snp.makeConstraints { make in
            make.leading.equalTo(badgeImage.snp.trailing)
            make.centerY.equalTo(descriptionLabel01)
        }
        descriptionLabel03.snp.makeConstraints { make in
            make.leading.equalTo(descriptionLabel01)
            make.top.equalTo(descriptionLabel01.snp.bottom).offset(5)
        }
        firstStepLabel.snp.makeConstraints { make in
            make.leading.equalTo(sinzakAuthorLabel)
            make.top.equalTo(descriptionLabel03.snp.bottom).offset(44)
        }
        schoolLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstStepLabel)
            make.top.equalTo(firstStepLabel.snp.bottom).offset(18)
        }
        schoolAuthButton.snp.makeConstraints { make in
            make.centerY.equalTo(schoolLabel)
            make.trailing.equalToSuperview().inset(26)
            make.width.equalTo(72)
            make.height.equalTo(30)
        }
        schoolNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(schoolLabel.snp.trailing).offset(12)
            make.centerY.equalTo(schoolLabel)
            make.trailing.equalTo(schoolAuthButton.snp.leading).offset(-12)
        }
        secondStepLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstStepLabel)
            make.top.equalTo(schoolLabel.snp.bottom).offset(44)
        }
        secondStepDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(secondStepLabel)
            make.top.equalTo(secondStepLabel.snp.bottom).offset(6)
        }
        portfolioLinkTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(38)
            make.top.equalTo(secondStepDescriptionLabel.snp.bottom).offset(6)
        }
    }
}
