//
//  ProfileView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/12.
//

import UIKit

import SnapKit
import Then

final class ProfileView: SZView {
    // MARK: - Properties
    
    let profileType: ProfileType
    
    // MARK: - UI
    
    // 스크롤 뷰
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // 전체 스택뷰
    let wholeStackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // 1. 상단 뷰
    let headView = UIView().then {
        $0.backgroundColor = .clear
    }
    // 프로필 이미지
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.image = UIImage(named: "chat-thumbnail")
        $0.backgroundColor = CustomColor.gray10
    }
    // 이름, 뱃지
    let nameLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "김신작"
    }
    let badgeImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "verified-badge")
    }
    let nameBadgeStack = UIStackView().then {
        $0.spacing = 0
        $0.axis = .horizontal
    }
    // 학교, 인증
    let schoolNameLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.label
        $0.text = "홍익대학교"
    }
    let verifiedLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.purple
        $0.text = " verified"
    }
    let schoolVerifiedStack = UIStackView().then {
        $0.spacing = 0
        $0.axis = .horizontal
    }
    // 팔로워, 팔로잉
    let followerNumberLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "32"
    }
    private let followerLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.label
        $0.text = "팔로워"
    }
    let followingNumberLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "25"
    }
    private let followingLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.label
        $0.text = "팔로잉"
    }
    let followerStack = UIStackView().then {
        $0.spacing = 5
        $0.axis = .horizontal
    }
    let followingStack = UIStackView().then {
        $0.spacing = 5
        $0.axis = .horizontal
    }
    let followerFollowingStack = UIStackView().then {
        $0.spacing = 30
        $0.axis = .horizontal
    }
    // 소개멘트
    let introduceLabel = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.label
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "자유롭게 작업합니다\nInstagram @jiiiiho_0"
    }
    // 프로필편집 버튼
    let profileEditButton = UIButton().then {
        $0.setTitle("프로필 편집", for: .normal)
        $0.setTitleColor(CustomColor.label, for: .normal)
        $0.titleLabel?.font = .body_M
        $0.layer.cornerRadius = 21
        $0.clipsToBounds = true
        $0.layer.borderColor = CustomColor.label.cgColor
        $0.layer.borderWidth = 1
    }
    let followButton: FollowButton = {
        let button = FollowButton()
        
        return button
    }()
    // 2. 스크랩목록
    let scrapListView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let scrapListLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "스크랩 목록"
    }
    let scrapListButton = UIButton().then {
        $0.setImage(UIImage(named: "right-chevron-big")?.withTintColor(CustomColor.label, renderingMode: .alwaysOriginal), for: .normal)
    }
    let scrapListSeperator = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    // 3. 의뢰해요
    let requestListView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let requestListLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "의뢰해요"
    }
    let requestListButton = UIButton().then {
        $0.setImage(UIImage(named: "right-chevron-big")?.withTintColor(CustomColor.label, renderingMode: .alwaysOriginal), for: .normal)
    }
    let requestListSeperator = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    // 4. 판매작품
    let salesListView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let salesListLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "판매 작품"
    }
//    let salesListImage01 = UIImageView().then {
//        $0.contentMode = .scaleAspectFit
//        $0.image = UIImage(named: "empty-face-image")
//        $0.layer.cornerRadius = 12
//        $0.clipsToBounds = true
//        $0.layer.shadowColor = CustomColor.label.withAlphaComponent(0.25).cgColor
//        $0.layer.shadowRadius = 8
//        $0.layer.shadowOffset = CGSize(width: 4, height: 2)
//    }
//    let salesListImage02 = UIImageView().then {
//        $0.contentMode = .scaleAspectFit
//        $0.image = UIImage(named: "empty-face-image")
//        $0.layer.cornerRadius = 12
//        $0.clipsToBounds = true
//        $0.layer.shadowColor = CustomColor.label.withAlphaComponent(0.25).cgColor
//        $0.layer.shadowRadius = 8
//        $0.layer.shadowOffset = CGSize(width: 4, height: 2)
//    }
    let salesListButton = UIButton().then {
        $0.setImage(
            UIImage(named: "right-chevron-big")?.withTintColor(CustomColor.label, renderingMode: .alwaysOriginal),
            for: .normal
        )
    }
    
    let salesListSeperator = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    
    // 5. 작업해요
    let workListView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let workListLabel = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "작업해요"
    }
//    let workListImage01 = UIImageView().then {
//        $0.contentMode = .scaleAspectFit
//        $0.image = UIImage(named: "emptySquare")
//        $0.layer.cornerRadius = 12
//        $0.clipsToBounds = true
//        $0.layer.shadowColor = CustomColor.label.withAlphaComponent(0.25).cgColor
//        $0.layer.shadowRadius = 8
//        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
//    }
//    let workListImage02 = UIImageView().then {
//        $0.contentMode = .scaleAspectFit
//        $0.image = UIImage(named: "emptySquare")
//        $0.layer.cornerRadius = 12
//        $0.clipsToBounds = true
//        $0.layer.shadowColor = CustomColor.label.withAlphaComponent(0.25).cgColor
//        $0.layer.shadowRadius = 8
//        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
//    }
    let workListButton = UIButton().then {
        $0.setImage(
            UIImage(named: "right-chevron-big")?.withTintColor(CustomColor.label, renderingMode: .alwaysOriginal),
            for: .normal
        )
    }
    
    let workListSeperator = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    
    let profileSkeletonView = ProfileSkeletonView()
    
    init(profileType: ProfileType) {
        self.profileType = profileType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProfile(with profile: Profile) {
        
        if case .others = profileType {
            scrapListView.isHidden = true
            requestListView.isHidden = true
        }
        
        let url = URL(string: profile.imageURL)
        self.profileImage.kf.setImage(with: url)
        
        nameLabel.text = profile.name
        if !profile.certAuthor {
            nameBadgeStack.removeArrangedSubview(badgeImage)
            badgeImage.isHidden = true
        }
        
        if profile.univ.isEmpty {
            schoolVerifiedStack.isHidden = true
            followerFollowingStack.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(nameBadgeStack.snp.bottom).offset(12)
            }
        } else {
            schoolNameLabel.text = profile.univ
            
            if profile.certUni {
                verifiedLabel.text = " verified"
                verifiedLabel.textColor = CustomColor.red50
            } else {
                verifiedLabel.text = " unverified"
                verifiedLabel.textColor = CustomColor.gray60
            }
        }
        
        followingNumberLabel.text = profile.followingNumber
        
        introduceLabel.text = profile.introduction
    }
    
    // MARK: - Design Helpers
    override func setView() {
        isSkeletonable = true
        addSubviews(
            scrollView,
            profileSkeletonView
        )
        scrollView.addSubview(wholeStackView)
        wholeStackView.addArrangedSubviews(
            headView,
            scrapListView,
            requestListView,
            salesListView,
            workListView
        )
        // 작업해요
        workListView.addSubviews(
            workListLabel,
//            workListImage01,
//            workListImage02,
            workListButton,
            workListButton,
            workListSeperator
        )
        // 판매작품
        salesListView.addSubviews(
            salesListLabel,
//            salesListImage01,
//            salesListImage02,
            salesListButton,
            salesListSeperator
        )
        // 외주해요
        requestListView.addSubviews(
            requestListLabel,
            requestListButton,
            requestListSeperator
        )
        // 스크랩목록
        scrapListView.addSubviews(
            scrapListLabel,
            scrapListButton,
            scrapListSeperator
        )
        // 상단쪽
        headView.addSubviews(
            profileImage,
            nameBadgeStack,
            schoolVerifiedStack,
            followerFollowingStack,
            introduceLabel
        )
        switch profileType {
        case .mine:     headView.addSubview(profileEditButton)
        case .others:   headView.addSubview(followButton)
        }
        
        nameBadgeStack.addArrangedSubviews(
            nameLabel, badgeImage
        )
        schoolVerifiedStack.addArrangedSubviews(
            schoolNameLabel, verifiedLabel
        )
        followerFollowingStack.addArrangedSubviews(
            followerStack,
            followingStack
        )
        followerStack.addArrangedSubviews(
            followerNumberLabel,
            followerLabel
        )
        followingStack.addArrangedSubviews(
            followingNumberLabel,
            followingLabel
        )
    }
    override func setLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        wholeStackView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview()
        }
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(73)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(23)
        }
        nameBadgeStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImage.snp.bottom).offset(12)
        }
        badgeImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        schoolVerifiedStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameBadgeStack.snp.bottom).offset(12)
        }
        followerFollowingStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(schoolVerifiedStack.snp.bottom).offset(24)
        }
        introduceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(followerFollowingStack.snp.bottom).offset(24)
            make.leading.trailing.lessThanOrEqualToSuperview().inset(37.5)
        }
        switch profileType {
        case .mine:
            profileEditButton.snp.makeConstraints { make in
                make.width.equalTo(204)
                make.height.equalTo(42)
                make.centerX.equalToSuperview()
                make.top.equalTo(introduceLabel.snp.bottom).offset(20)
                make.bottom.equalToSuperview().inset(20)
            }
        case .others:
            followButton.snp.makeConstraints {
                $0.width.equalTo(136.0)
                $0.height.equalTo(42.0)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(introduceLabel.snp.bottom).offset(20)
                $0.bottom.equalToSuperview().inset(20)
            }
        }
        headView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        scrapListView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(63)
        }
        scrapListLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(28)
        }
        scrapListButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(26.5)
        }
        scrapListSeperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(0.5)
        }
        
        requestListView.snp.makeConstraints { make in
            make.top.equalTo(scrapListView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(63)
        }
        requestListLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(28)
        }
        requestListButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(26.5)
        }
        requestListSeperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(0.5)
        }
        
        salesListView.snp.makeConstraints { make in
            make.top.equalTo(requestListView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(63)
        }
        salesListLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(28)
            make.top.equalToSuperview().inset(24)
        }
//        salesListImage01.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(18)
//            make.top.equalTo(salesListLabel.snp.bottom).offset(10)
//            make.width.equalToSuperview().multipliedBy(0.4)
//            make.height.equalTo(salesListImage01.snp.width)
//            make.bottom.equalToSuperview().inset(24)
//        }
//        salesListImage02.snp.makeConstraints { make in
//            make.width.height.top.bottom.equalTo(salesListImage01)
//            make.leading.equalTo(salesListImage01.snp.trailing).offset(12.5)
//        }
        salesListButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(26.5)
        }
        salesListSeperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(0.5)
        }
        
        workListView.snp.makeConstraints { make in
            make.top.equalTo(salesListView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(63)
        }
        workListLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(28)
        }
//        workListImage01.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(18)
//            make.top.equalTo(workListLabel.snp.bottom).offset(10)
//            make.width.equalToSuperview().multipliedBy(0.4)
//            make.height.equalTo(workListImage01.snp.width)
//            make.bottom.equalToSuperview().inset(50)
//        }
//        workListImage02.snp.makeConstraints { make in
//            make.width.height.top.bottom.equalTo(workListImage01)
//            make.leading.equalTo(workListImage01.snp.trailing).offset(12.5)
//        }
        workListButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(26.5)
        }
        workListSeperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(0.5)
        }
        
        profileSkeletonView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
