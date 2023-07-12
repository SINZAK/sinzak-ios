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
        $0.backgroundColor = CustomColor.gray10
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.image = UIImage(named: "chat-thumbnail")
    }
    // 프로필 사진 변경
    let changeProfileImageButton = UIButton().then {
        $0.setTitle("프로필 사진 바꾸기", for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.titleLabel?.font = .caption_M
    }
    // 닉네임
    let nicknameView = UIView()
    private let nicknameLabel = UILabel().then {
        $0.tintColor = CustomColor.red
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.text = "닉네임"
    }
    
    let currentNickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.label
        label.font = .body_R
        label.text = "current nick"
        
        return label
    }()
//    let nicknameTextField = UITextField().then {
//        $0.tintColor = CustomColor.red
//        $0.placeholder = "닉네임"
//        $0.font = .body_R
//        $0.textColor = CustomColor.label
//    }
//    let checkButton = DoubleCheckButton().then {
//        $0.setTitle("중복확인", for: .normal)
//        $0.setTitleColor(CustomColor.gray60, for: .normal)
//        $0.titleLabel?.font = .caption_B
//        $0.layer.borderColor = CustomColor.gray60.cgColor
//        $0.layer.borderWidth = 1
//        $0.layer.cornerRadius = 15
//        $0.isEnabled = false
//    }
//
//    let nameValidationLabel = UILabel().then {
//        $0.font = .caption_R
//        $0.textColor = CustomColor.purple
//        $0.text = "사용불가능한 이름입니다."
//        $0.isHidden = true
//    }
    
    // 소개
    let introductionView = UIView()
    private let introductionLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.text = "소개"
    }
    let introductionTextView = UITextView().then {
        $0.tintColor = CustomColor.red
        $0.backgroundColor = CustomColor.background
        $0.font = .caption_R
        $0.textColor = CustomColor.label
        $0.isScrollEnabled = false
        $0.text = "자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다자유롭게 작업합니다"
    }
    
    let textViewPlaceHolderLabel: UILabel = {
        let label = UILabel() 
        label.textColor = CustomColor.gray60
        label.font = .body_R
        label.text = "소개를 입력해 주세요."
        
        return label
    }()
    
    let introductionCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .buttonText_R
        $0.textColor = CustomColor.label
    }
    private let limitIntroductionLabel = UILabel().then {
        $0.text = "/100"
        $0.font = .buttonText_R
        $0.textColor = CustomColor.label
    }
    // 학교
    let schoolView = UIView()
    private let schoolLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.text = "학교"
    }
    let schoolNameLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.label
        $0.text = "홍익대학교"
    }
    let verifySchoolButton = VerifyButton().then {
        $0.titleLabel?.font = .body_M
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.setTitle("인증하기", for: .normal)
    }
    // 관심장르
    let genreView = UIView()
    private let genreLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.text = "관심장르"
    }
    let genreNameLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.label
        $0.text = "일반회화"
        $0.numberOfLines = 0
        $0.addInterlineSpacing(spacing: 8.0)
    }
    let changeGenreButton = UIButton().then {
        $0.titleLabel?.font = .body_M
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.setTitle("변경하기", for: .normal)
    }
    // 인증작가 신청하기 버튼
    let applyAuthorView = UIView()
    let applyAuthorButton = UIButton().then {
        $0.setTitle("인증작가 신청하기", for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.titleLabel?.font = .caption_M
        $0.isHidden = true
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
    
    func configureProfile(with profile: Profile) {
        let imageURL = URL(string: profile.imageURL)
        profileImage.kf.setImage(with: imageURL)
        
        currentNickNameLabel.text = profile.name
        
        introductionTextView.text = profile.introduction
        textViewPlaceHolderLabel.isHidden = !profile.introduction.isEmpty
        introductionCountLabel.text = "\(profile.introduction.count)"
        
        schoolNameLabel.text = profile.univ
        
        verifySchoolButton.isEnabled = !profile.certUni
        
        let categoryLike: String = profile.categoryLike
            .split(separator: ",")
            .map { AllGenre(rawValue: String($0)) }
            .map { $0?.text ?? "" }
            .joined(separator: "\n")
        
        genreNameLabel.text = categoryLike
                
        applyAuthorButton.isEnabled = !profile.certAuthor 
    }
    
    // MARK: - Design Helpers
    override func setView() {
        addSubview(
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
            currentNickNameLabel
        )
        introductionView.addSubviews(
            introductionLabel,
            introductionTextView,
            textViewPlaceHolderLabel,
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
            make.bottom.equalTo(currentNickNameLabel.snp.bottom).offset(20.0)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20.0)
        }
        nicknameLabel.setContentHuggingPriority(
            .defaultHigh,
            for: .horizontal
        )
        currentNickNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(30)
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
        textViewPlaceHolderLabel.snp.makeConstraints {
            $0.centerY.trailing.equalTo(introductionTextView)
            $0.leading.equalTo(introductionTextView).offset(4.0)
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
            let minHeight = 16.0 + 19.0 + 19.0
            
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(genreNameLabel.snp.bottom).offset(20.0)
            make.height.greaterThanOrEqualTo(minHeight)
        }
        genreLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(19)
        }
        genreNameLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel)
            make.leading.equalTo(genreLabel.snp.trailing).offset(30)
            make.trailing.equalTo(changeGenreButton.snp.leading).offset(-10)
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
