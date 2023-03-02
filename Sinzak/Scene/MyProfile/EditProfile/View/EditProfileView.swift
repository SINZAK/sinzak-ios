//
//  EditProfileView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/02.
//

import UIKit
import SnapKit
import Then

final class EditProfileView: SZView {
    // MARK: - Properties
    // 스크롤 뷰
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // 전체 스택뷰
    let stackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // 프로필 뷰
    // 프로필 사진
    let profileView = UIView()
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.image = UIImage(named: "chat-thumbnail")
    }
    // 프로필 사진 변경
    let changeProfileImageButton = UIButton().then {
        $0.setTitle(I18NStrings.changeProfilePhoto, for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.titleLabel?.font = .caption_M
    }
    // 닉네임
    let nicknameView = UIView()
    private let nicknameLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.nickname
    }
    let nicknameTextField = UITextField().then {
        $0.placeholder = I18NStrings.nickname
        $0.font = .body_R
        $0.textColor = CustomColor.black
    }
    // 소개
    let introductionView = UIView()
    private let introductionLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.introduction
    }
    let introductionTextView = UITextView().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.black
        $0.isScrollEnabled = false
        $0.text = "자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다"
    }
    let introductionCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .buttonText_R
        $0.textColor = CustomColor.black
    }
    private let limitIntroductionLabel = UILabel().then {
        $0.text = "/100"
        $0.font = .buttonText_R
        $0.textColor = CustomColor.black
    }
    // 학교
    let schoolView = UIView()
    private let schoolLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.school
    }
    let schoolNameLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.black
        $0.text = "홍익대학교"
    }
    let verifySchoolButton = UIButton().then {
        $0.titleLabel?.font = .body_M
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.setTitle(I18NStrings.verify, for: .normal)
    }
    // 관심장르
    let genreView = UIView()
    private let genreLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.genreOfInterest
    }
    let genreNameLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.black
        $0.text = "일반회화"
    }
    let changeGenreButton = UIButton().then {
        $0.titleLabel?.font = .body_M
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.setTitle(I18NStrings.change, for: .normal)
    }
    // 인증작가 신청하기 버튼
    let applyAuthorView = UIView()
    let applyAuthorButton = UIButton().then {
        $0.setTitle(I18NStrings.applyCertifiedAuthor, for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.titleLabel?.font = .caption_M
    }
    // 디바이더
    private let divider01 = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    private let divider02 = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    private let divider03 = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    private let divider04 = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubview (
            scrollView
        )
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(
            profileView,
            nicknameView,
            divider01,
            introductionView,
            divider02,
            schoolView,
            divider03,
            genreView,
            divider04,
            applyAuthorView
        )
        profileView.addSubviews(
            profileImage,
            changeProfileImageButton
        )
        nicknameView.addSubviews(
            nicknameLabel,
            nicknameTextField
        )
        introductionView.addSubviews(
            introductionLabel,
            introductionTextView,
            introductionCountLabel,
            limitIntroductionLabel
        )
        schoolView.addSubviews(
            schoolLabel, schoolNameLabel, verifySchoolButton
        )
        genreView.addSubviews(
            genreLabel, genreNameLabel, changeGenreButton
        )
        applyAuthorView.addSubview(applyAuthorButton)
    }
    override func setLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview()
        }
        profileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.width.height.equalTo(73)
            make.centerX.equalToSuperview()
        }
        changeProfileImageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(13)
            make.centerX.equalTo(profileImage)
            make.width.equalTo(140)
            make.bottom.equalToSuperview().inset(5)
        }
        nicknameView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(19)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(30)
            make.trailing.lessThanOrEqualToSuperview().inset(38)
        }
        divider01.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(0.5)
        }
        introductionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        introductionLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(19)
        }
        introductionTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37.5)
            make.top.equalTo(introductionLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualTo(limitIntroductionLabel.snp.top).offset(-7)
        }
        limitIntroductionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(37.5)
            make.bottom.equalToSuperview().inset(12)
            make.top.equalTo(introductionTextView.snp.bottom).offset(7)
        }
        introductionCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(limitIntroductionLabel.snp.leading)
            make.centerY.equalTo(limitIntroductionLabel)
        }
        divider02.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(0.5)
        }
        schoolView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(divider02.snp.bottom)
        }
        schoolLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(19)
        }
        schoolNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(schoolLabel)
            make.leading.equalTo(genreNameLabel)
            make.trailing.lessThanOrEqualTo(verifySchoolButton.snp.leading).offset(-10)
        }
        verifySchoolButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(72)
            make.height.equalTo(40)
            make.centerY.equalTo(schoolLabel)
        }
        divider03.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(0.5)
        }
        genreView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        genreLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(19)
        }
        genreNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(genreLabel)
            make.leading.equalTo(genreLabel.snp.trailing).offset(30)
            make.trailing.lessThanOrEqualTo(changeGenreButton.snp.leading).offset(-10)
        }
        changeGenreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(72)
            make.height.equalTo(40)
            make.centerY.equalTo(genreLabel)
        }
        divider04.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(0.5)
        }
        applyAuthorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        applyAuthorButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(19)
            make.width.equalTo(110)
            make.height.equalTo(24)
        }
    }
}
