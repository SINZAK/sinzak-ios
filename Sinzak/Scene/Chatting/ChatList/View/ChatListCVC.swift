//
//  ChatListCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class ChatListCVC: UICollectionViewCell {
    // MARK: - Properties
    let chatThumbnail = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.image = UIImage(named: "chat-thumbnail")
    }
    let nameBadgestack = UIStackView().then {
        $0.spacing = 3
        $0.axis = .horizontal
    }
    let nameLabel = UILabel().then {
        $0.text = "김신작"
        $0.textColor = CustomColor.black
        $0.font = .body_M
    }
    let verifiedBadge = UIImageView().then {
        $0.image = UIImage(named: "verified-badge")
        $0.isHidden = false
    }
    let schoolLabel = UILabel().then {
        $0.text = "홍익대"
        $0.textColor = CustomColor.gray60
        $0.font = .caption_R
    }
    private let middlePoint = UILabel().then {
        $0.text = "·"
        $0.textColor = CustomColor.gray60
        $0.font = .caption_R
    }
    let timeLabel = UILabel().then {
        $0.text = "2일 전"
        $0.textColor = CustomColor.gray60
        $0.font = .caption_R
    }
    let talkLabel = UILabel().then {
        $0.text = "정유빈님이 이모티콘을 보냈어요."
        $0.textColor = CustomColor.black
        $0.font = .body_R
    }
    let chatCountBackground = UIView().then {
        $0.backgroundColor = CustomColor.purple
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isHidden = false
    }
    let chatCountLabel = UILabel().then {
        $0.text = "1"
        $0.textColor = CustomColor.white
        $0.font = .caption_M
        $0.textAlignment = .center
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Design Helpers
    func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(
            chatThumbnail, nameBadgestack,chatCountBackground,
            schoolLabel, middlePoint, timeLabel,
            talkLabel
        )
        nameBadgestack.addArangedSubviews(
            nameLabel, verifiedBadge
        )
        chatCountBackground.addSubview(
            chatCountLabel
        )
    }
    func setConstraints() {
        chatThumbnail.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.top.bottom.leading.equalToSuperview().inset(17)
            make.centerY.equalToSuperview()
        }
        chatCountBackground.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        chatCountLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        nameBadgestack.snp.makeConstraints { make in
            make.leading.equalTo(chatThumbnail.snp.trailing).offset(15)
            make.top.equalTo(chatThumbnail)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        verifiedBadge.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        schoolLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameBadgestack.snp.trailing).offset(9)
            make.centerY.equalTo(nameBadgestack)
        }
        middlePoint.snp.makeConstraints { make in
            make.leading.equalTo(schoolLabel.snp.trailing)
            make.centerY.equalTo(schoolLabel)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(middlePoint.snp.trailing)
            make.centerY.equalTo(middlePoint)
        }
        talkLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chatThumbnail)
            make.leading.equalTo(nameBadgestack)
            make.top.greaterThanOrEqualTo(nameBadgestack.snp.bottom).offset(2)
        }
    }
}
