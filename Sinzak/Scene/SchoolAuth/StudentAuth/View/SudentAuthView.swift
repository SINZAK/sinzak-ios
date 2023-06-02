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
            return CustomColor.white
        case .not:
            return CustomColor.label
        }
    }
    var backgroundColor: UIColor {
        switch self {
        case .selected:
            return CustomColor.red
        case .not:
            return CustomColor.gray10
        }
    }
    var image: UIImage {
        switch self {
        case .selected:
            return UIImage(named: "checkmark-white")!
        case .not:
            return UIImage(named: "checkmark-black")!.withTintColor(
                .label,
                renderingMode: .alwaysOriginal
            )
        }
    }
}

final class StudentAuthView: SZView {
    // MARK: - Properties

    let selectAuthTypeLabel = UILabel().then {
        $0.text = "인증 방식 선택"
        $0.textColor = CustomColor.label
        $0.font = .caption_M
    }
    // 상단 인증타입 버튼
    let authButtonStack = UIStackView().then {
        $0.spacing = 13
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let webmailButton = UIButton().then {
        $0.setTitle("학교 웹메일 인증", for: .normal)
        $0.setTitleColor(ButtonSelected.selected.foregroundColor, for: .normal)
        $0.tintColor = ButtonSelected.selected.foregroundColor
        $0.setImage(ButtonSelected.selected.image, for: .normal)
        $0.backgroundColor = ButtonSelected.selected.backgroundColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = .caption_B
    }
    let schoolcardButton = UIButton().then {
        $0.setTitle("학생증 인증", for: .normal)
        $0.setTitleColor(ButtonSelected.not.foregroundColor, for: .normal)
        $0.tintColor = ButtonSelected.not.foregroundColor
        $0.setImage(ButtonSelected.not.image, for: .normal)
        $0.backgroundColor = ButtonSelected.not.backgroundColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = .caption_B
    }
    // 인증별 뷰
    // - 웹메일 인증
    
    let webmailView = SZView()
    
    let webmailDescription = UILabel().then {
        $0.text = "이메일을 입력하면 인증 메일을 보내드립니다.\n이메일 수신 후 인증번호를 입력하면 인증이 완료됩니다."
        $0.font = .caption_R
        $0.textColor = CustomColor.label
        $0.addInterlineSpacing(spacing: 3)
        $0.numberOfLines = 2
    }
    let webmailTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).then {
        $0.keyboardType = .emailAddress
        $0.returnKeyType = .done
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22.0
        $0.font = .caption_B
        $0.textColor = CustomColor.label
        $0.placeholder = "학교메일을 입력하세요."
        $0.clearButtonMode = .whileEditing
    }
    
    let transmitMailButton: DoubleCheckButton = {
        let button = DoubleCheckButton()
        button.layer.cornerRadius = 15.0
        button.setTitle("전송", for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    let webmailValidationLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.red
        $0.text = ""
    }
    let authCodeLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.label.withAlphaComponent(0)
        $0.text = "인증번호"
        $0.isHidden = true
        $0.alpha = 0
    }
    let authCodeTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).then {
        $0.isSecureTextEntry = true
        $0.keyboardType = .numberPad
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22.0
        $0.font = .caption_B
        $0.textColor = CustomColor.label
        $0.placeholder = "4자리 인증번호를 입력해주세요."
        $0.clearButtonMode = .whileEditing
        $0.isHidden = true
        $0.alpha = 0
    }
    
    let confirmCodeButton: DoubleCheckButton = {
        let button = DoubleCheckButton()
        button.layer.cornerRadius = 15.0
        button.setTitle("확인", for: .normal)
        button.isEnabled = false
        button.isHidden = true
        button.alpha = 0
        
        return button
    }()
    
    let authCodeValidationLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.red
        $0.text = ""
        $0.isHidden = true
        $0.alpha = 0
    }
    // - 학생증 인증
    let schoolCardView = SZView().then {
        $0.isHidden = true
    }
    let schoolCardDescription = UILabel().then {
        $0.text = "모바일 학생증 캡쳐 화면 또는 실물 학생증 사진을\n업로드해주세요. 2~3일 내에 승인이 완료됩니다."
        $0.font = .caption_R
        $0.textColor = CustomColor.label
        $0.addInterlineSpacing(spacing: 3)
        $0.numberOfLines = 2
    }
    let photoUploadButton = UIButton().then {
        $0.setTitle(" "+"사진 업로드하기", for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.setImage(UIImage(named: "camera"), for: .normal)
        $0.tintColor = CustomColor.purple
        $0.layer.borderColor = CustomColor.purple.cgColor
        $0.titleLabel?.font = .body_B
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
    }
    let uploadedPhotoView = UIView().then {
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        $0.layer.borderColor = CustomColor.label.cgColor
        $0.layer.borderWidth = 2
        $0.isHidden = true
    }
    
    let uploadedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let selectedPhoto: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        $0.layer.borderColor = CustomColor.gray40.cgColor
        $0.layer.borderWidth = 2
        $0.isHidden = true
        $0.contentMode = .scaleAspectFill
    }
    let photoNameLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "F48A6CC-C83EE822..."
    }
    let cancelButton = UIButton().then {
        $0.setImage(UIImage(named: "x-circle"), for: .normal)
    }
    // 하단 버튼
    let webMailButtonStack = UIStackView().then {
        $0.spacing = 12
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let webMailDoNextButton = UIButton().then {
        $0.setTitle("다음에 하기", for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.gray60
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    let webMailFinishButton = SchoolAuthButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.red
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
        $0.isEnabled = false
    }
    
    let schoolCardButtonStack = UIStackView().then {
        $0.spacing = 12
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let schoolCardDoNextButton = UIButton().then {
        $0.setTitle("다음에 하기", for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.gray60
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    let schoolCardFinishButton = SchoolAuthButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.red
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
        $0.isEnabled = false
    }
    // MARK: - Design Changer
    func changeButtonStatus(_ selected: SchoolAuthType ) {
        switch selected {
        case .webmail:
            webmailButton.setTitleColor(ButtonSelected.selected.foregroundColor, for: .normal)
            webmailButton.setImage(ButtonSelected.selected.image, for: .normal)
            webmailButton.backgroundColor = ButtonSelected.selected.backgroundColor
            schoolcardButton.setTitleColor(ButtonSelected.not.foregroundColor, for: .normal)
            schoolcardButton.setImage(ButtonSelected.not.image, for: .normal)
            schoolcardButton.backgroundColor = ButtonSelected.not.backgroundColor
        case .idcard:
            schoolcardButton.setTitleColor(ButtonSelected.selected.foregroundColor, for: .normal)
            schoolcardButton.setImage(ButtonSelected.selected.image, for: .normal)
            schoolcardButton.backgroundColor = ButtonSelected.selected.backgroundColor
            webmailButton.setTitleColor(ButtonSelected.not.foregroundColor, for: .normal)
            webmailButton.setImage(ButtonSelected.not.image, for: .normal)
            webmailButton.backgroundColor = ButtonSelected.not.backgroundColor
        }
    }
    // MARK: - Design Helpers
    override func setView() {

        addSubviews(
            selectAuthTypeLabel,
            authButtonStack,
            schoolCardView,
            webmailView
        )
        
        authButtonStack.addArrangedSubviews(
            webmailButton,
            schoolcardButton
        )
        webmailView.addSubviews(
            webmailDescription,
            webmailTextField, transmitMailButton,
            webmailValidationLabel,
            authCodeLabel,
            authCodeTextField, confirmCodeButton,
            authCodeValidationLabel,
            webMailButtonStack
        )
        schoolCardView.addSubviews(
            schoolCardDescription,
            photoUploadButton,
            uploadedPhotoView,
            uploadedImageView,
            selectedPhoto,
            schoolCardButtonStack
        )
        uploadedPhotoView.addSubviews(
            photoNameLabel,
            cancelButton
        )
        
        webMailButtonStack.addArrangedSubviews(
            webMailDoNextButton, webMailFinishButton
        )
        schoolCardButtonStack.addArrangedSubviews(
            schoolCardDoNextButton, schoolCardFinishButton
        )
    }
    override func setLayout() {

        selectAuthTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.top.equalTo(safeAreaLayoutGuide).offset(20.0)
        }
        authButtonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(31)
            make.top.equalTo(selectAuthTypeLabel.snp.bottom).offset(6)
            make.height.equalTo(40)
        }
    
        // MARK: - 메일 인증 뷰
        webmailView.snp.makeConstraints { make in
            make.top.equalTo(authButtonStack.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        webmailDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(34)
            make.top.equalToSuperview().inset(36.0)
        }
        webmailTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(transmitMailButton.snp.leading).offset(-6.0)
            make.top.equalTo(webmailDescription.snp.bottom).offset(12)
            make.height.equalTo(44.0)
        }
        
        transmitMailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalTo(webmailTextField)
            $0.width.equalTo(64.0)
            $0.height.equalTo(30.0)
        }
        
        webmailValidationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(28)
            make.top.equalTo(webmailTextField.snp.bottom).offset(8.0)
        }
        authCodeLabel.snp.makeConstraints { make in
            make.leading.equalTo(webmailDescription)
            make.top.equalTo(webmailValidationLabel.snp.bottom).offset(28.0)
        }
        authCodeTextField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(webmailTextField)
            make.top.equalTo(authCodeLabel.snp.bottom).offset(4)
        }
        
        confirmCodeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalTo(authCodeTextField)
            $0.width.equalTo(64.0)
            $0.height.equalTo(30.0)
        }
        
        authCodeValidationLabel.snp.makeConstraints { make in
            make.leading.equalTo(webmailValidationLabel)
            make.top.equalTo(authCodeTextField.snp.bottom).offset(8.0)
        }
        
        // 학생증 인증 뷰
        schoolCardView.snp.makeConstraints { make in
            make.top.equalTo(authButtonStack.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        schoolCardDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(34)
            make.top.equalToSuperview().inset(36.0)
        }
        photoUploadButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.width.equalTo(192)
            make.height.equalTo(48)
            make.top.equalTo(schoolCardDescription.snp.bottom).offset(16)
        }
        uploadedPhotoView.snp.makeConstraints { make in
            make.edges.equalTo(photoUploadButton)
        }
        
        uploadedImageView.snp.makeConstraints {
            $0.top.equalTo(uploadedPhotoView.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(200.0)
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
        selectedPhoto.snp.makeConstraints { make in
            make.top.equalTo(uploadedPhotoView.snp.bottom).offset(26)
            make.horizontalEdges.equalToSuperview().inset(36)
            make.height.equalTo(selectedPhoto.snp.width).multipliedBy(0.7)
        }
        
        // 하단 버튼
        webMailButtonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24.0)
            make.height.equalTo(65)
        }
        
        schoolCardButtonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24.0)
            make.height.equalTo(65)
        }
    }
}
