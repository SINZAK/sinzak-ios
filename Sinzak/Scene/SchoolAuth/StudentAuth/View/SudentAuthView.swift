//
//  StudentAuthView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import SnapKit
import Then

enum SchoolAuthType {
    case webmail
    case idcard
}

enum ButtonSelected {
    case selected
    case not
    var foregroundColor: UIColor {
        switch self {
        case .selected:
            return CustomColor.white!
        case .not:
            return CustomColor.black!
        }
    }
    var backgroundColor: UIColor {
        switch self {
        case .selected:
            return CustomColor.red!
        case .not:
            return CustomColor.gray10!
        }
    }
    var image: String {
        switch self {
        case .selected:
            return "checkmark-white"
        case .not:
            return "checkmark-black"
        }
    }
}

final class StudentAuthView: SZView {
    // MARK: - Properties
    let selectAuthTypeLabel = UILabel().then {
        $0.text = I18NStrings.verifyTypeSelect
        $0.textColor = CustomColor.black
        $0.font = .caption_M
    }
    // 상단 인증타입 버튼
    let authButtonStack = UIStackView().then {
        $0.spacing = 13
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let webmailButton = UIButton().then {
        $0.setTitle(I18NStrings.schoolWebmailAuth, for: .normal)
        $0.setTitleColor(ButtonSelected.selected.foregroundColor, for: .normal)
        $0.tintColor = ButtonSelected.selected.foregroundColor
        $0.setImage(UIImage(named: ButtonSelected.selected.image), for: .normal)
        $0.backgroundColor = ButtonSelected.selected.backgroundColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = .caption_B
    }
    let schoolcardButton = UIButton().then {
        $0.setTitle(I18NStrings.schoolCardAuth, for: .normal)
        $0.setTitleColor(ButtonSelected.not.foregroundColor, for: .normal)
        $0.tintColor = ButtonSelected.not.foregroundColor
        $0.setImage(UIImage(named: ButtonSelected.not.image), for: .normal)
        $0.backgroundColor = ButtonSelected.not.backgroundColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = .caption_B
    }
    // 인증별 뷰
    // - 웹메일 인증
    let webmailView = UIView()
    let webmailDescription = UILabel().then {
        $0.text = I18NStrings.schoolEmailAuthDescription
        $0.font = .caption_R
        $0.textColor = CustomColor.black
        $0.addInterlineSpacing(spacing: 3)
        $0.numberOfLines = 2
    }
    let webmailTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).then {
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.font = .caption_B
        $0.textColor = CustomColor.black
        $0.placeholder = I18NStrings.pleaseEnterSchoolEmail
        $0.clearButtonMode = .whileEditing
    }
    let webmailValidationLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.red
        $0.text = I18NStrings.enterYourEmailInCorrectFormat
    }
    let authCodeLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.authCode
    }
    let authCodeTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).then {
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.font = .caption_B
        $0.textColor = CustomColor.black
        $0.placeholder = I18NStrings.fourDigitPlease
        $0.clearButtonMode = .whileEditing
    }
    let authCodeValidationLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.red
        $0.text = I18NStrings.pleaseEnterAgain
    }
    // - 학생증 인증
    let schoolCardView = UIView().then {
        $0.isHidden = true
    }
    let schoolCardDescription = UILabel().then {
        $0.text = I18NStrings.schoolCardAuthDescription
        $0.font = .caption_R
        $0.textColor = CustomColor.black
        $0.addInterlineSpacing(spacing: 3)
        $0.numberOfLines = 2
    }
    let photoUploadButton = UIButton().then {
        $0.setTitle(" "+I18NStrings.uploadPhotos, for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.setImage(UIImage(named: "camera"), for: .normal)
        $0.tintColor = CustomColor.purple
        $0.layer.borderColor = CustomColor.purple!.cgColor
        $0.titleLabel?.font = .body_B
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
    }
    let uploadedPhotoView = UIView().then {
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        $0.layer.borderColor = CustomColor.black!.cgColor
        $0.layer.borderWidth = 2
        $0.isHidden = true
    }
    let photoNameLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.text = "F48A6CC-C83EE822..."
    }
    let cancelButton = UIButton().then {
        $0.setImage(UIImage(named: "x-circle"), for: .normal)
    }
    // 하단 버튼
    let buttonStack = UIStackView().then {
        $0.spacing = 12
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let doNextButton = UIButton().then {
        $0.setTitle(I18NStrings.doNextTime, for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.gray60
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    let finishButton = UIButton().then {
        $0.setTitle(I18NStrings.finish, for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.red
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    // MARK: - Design Changer
    func changeButtonStatus(_ selected: SchoolAuthType ) {
        switch selected {
        case .webmail:
            webmailButton.setTitleColor(ButtonSelected.selected.foregroundColor, for: .normal)
            webmailButton.setImage(UIImage(named: ButtonSelected.selected.image), for: .normal)
            webmailButton.backgroundColor = ButtonSelected.selected.backgroundColor
            schoolcardButton.setTitleColor(ButtonSelected.not.foregroundColor, for: .normal)
            schoolcardButton.setImage(UIImage(named: ButtonSelected.not.image), for: .normal)
            schoolcardButton.backgroundColor = ButtonSelected.not.backgroundColor
        case .idcard:
            schoolcardButton.setTitleColor(ButtonSelected.selected.foregroundColor, for: .normal)
            schoolcardButton.setImage(UIImage(named: ButtonSelected.selected.image), for: .normal)
            schoolcardButton.backgroundColor = ButtonSelected.selected.backgroundColor
            webmailButton.setTitleColor(ButtonSelected.not.foregroundColor, for: .normal)
            webmailButton.setImage(UIImage(named: ButtonSelected.not.image), for: .normal)
            webmailButton.backgroundColor = ButtonSelected.not.backgroundColor
        }
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            selectAuthTypeLabel,
            authButtonStack,
            schoolCardView,
            webmailView,
            buttonStack
        )
        authButtonStack.addArrangedSubviews(
            webmailButton,
            schoolcardButton
        )
        webmailView.addSubviews(
            webmailDescription,
            webmailTextField,
            webmailValidationLabel,
            authCodeLabel,
            authCodeTextField,
            authCodeValidationLabel
        )
        schoolCardView.addSubviews(
            schoolCardDescription,
            photoUploadButton,
            uploadedPhotoView
        )
        uploadedPhotoView.addSubviews(
            photoNameLabel,
            cancelButton
        )
        buttonStack.addArrangedSubviews(
            doNextButton, finishButton
        )
    }
    override func setLayout() {
        selectAuthTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(36)
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
        }
        authButtonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(31)
            make.top.equalTo(selectAuthTypeLabel.snp.bottom).offset(6)
            make.height.equalTo(40)
        }
        webmailView.snp.makeConstraints { make in
            make.top.equalTo(authButtonStack.snp.bottom).offset(30)
            make.bottom.lessThanOrEqualTo(buttonStack.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview()
        }
        webmailDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(33)
            make.top.equalToSuperview()
        }
        webmailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(webmailDescription.snp.bottom).offset(12)
            make.height.equalTo(60)
        }
        webmailValidationLabel.snp.makeConstraints { make in
            make.leading.equalTo(webmailTextField).offset(18)
            make.top.equalTo(webmailTextField.snp.bottom).offset(3)
        }
        authCodeLabel.snp.makeConstraints { make in
            make.leading.equalTo(webmailDescription)
            make.top.equalTo(webmailValidationLabel.snp.bottom).offset(24)
        }
        authCodeTextField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(webmailTextField)
            make.top.equalTo(authCodeLabel.snp.bottom).offset(3)
        }
        authCodeValidationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(webmailValidationLabel)
            make.top.equalTo(authCodeTextField.snp.bottom).offset(3)
        }
        // 학생증 뷰
        schoolCardView.snp.makeConstraints { make in
            make.top.equalTo(authButtonStack.snp.bottom).offset(30)
            make.bottom.lessThanOrEqualTo(buttonStack.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview()
        }
        schoolCardDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(33)
            make.top.equalToSuperview()
        }
        photoUploadButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(33)
            make.width.equalTo(200)
            make.height.equalTo(48)
            make.top.equalTo(schoolCardDescription.snp.bottom).offset(16)
        }
        uploadedPhotoView.snp.makeConstraints { make in
            make.edges.equalTo(photoUploadButton)
        }
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(14)
        }
        photoNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-5)
        }
        // 하단 버튼
        buttonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(65)
        }
    }
}
