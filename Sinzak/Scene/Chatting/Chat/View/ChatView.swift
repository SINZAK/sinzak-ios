//
//  ChatView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class ChatView: SZView {
    // MARK: - Properties
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    // 상단 작품디테일쪽
    let artDetailView = UIView().then {
        $0.backgroundColor = CustomColor.white
    }
    let artThumbnail = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "art")
    }
    let isDealingLabel = UILabel().then {
        $0.text = "거래중"
        $0.textColor = CustomColor.black
        $0.font = .caption_B
    }
    let artTitleLabel = UILabel().then {
        $0.text = "작품명"
        $0.textColor = CustomColor.black
        $0.font = .caption_R
    }
    let artPriceLabel = UILabel().then {
        $0.text = "33,000원"
        $0.textColor = CustomColor.black
        $0.font = .caption_R
    }
    let isNotNegotiableButton = UIButton().then {
        $0.setTitle("가격제안불가", for: .normal)
        $0.tintColor = CustomColor.gray60!
        $0.titleLabel?.font = .caption_R
        $0.isUserInteractionEnabled = false
        $0.isHidden = false
    }
    let isNegotiableButton = UIButton().then {
        $0.setTitle("가격제안하기", for: .normal)
        $0.tintColor = CustomColor.purple!
        $0.titleLabel?.font = .caption_M
        $0.isHidden = false
    }
    // 하단 채팅레이블쪽
    let chatActionView = UIView().then {
        $0.backgroundColor = CustomColor.white
    }
    let albumButton = UIButton().then {
        $0.setImage(UIImage(named: "album"), for: .normal)
    }
    let chatTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)).then {
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 21
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.clearButtonMode = .whileEditing
        $0.placeholder = "메시지 보내기"
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            collectionView, artDetailView, chatActionView
        )
        artDetailView.addSubviews(
            artThumbnail, isDealingLabel, artTitleLabel, artPriceLabel,
            isNotNegotiableButton, isNegotiableButton
        )
        chatActionView.addSubviews(
            albumButton, chatTextField
        )
    }
    override func setLayout() {
        artDetailView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(67)
        }
        artThumbnail.snp.makeConstraints { make in
            make.width.height.equalTo(53)
            make.top.bottom.equalToSuperview().inset(7)
            make.leading.equalToSuperview().inset(22)
        }
        isDealingLabel.snp.makeConstraints { make in
            make.leading.equalTo(artThumbnail.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(19)
        }
        artTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(isDealingLabel.snp.trailing).offset(5)
            make.centerY.equalTo(isDealingLabel)
        }
        artPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(isDealingLabel)
            make.top.equalTo(isDealingLabel.snp.bottom).offset(10)
        }
        isNotNegotiableButton.snp.makeConstraints { make in
            make.leading.equalTo(artPriceLabel.snp.trailing).offset(4)
            make.centerY.equalTo(artPriceLabel)
        }
        isNegotiableButton.snp.makeConstraints { make in
            make.leading.equalTo(artPriceLabel.snp.trailing).offset(4)
            make.centerY.equalTo(artPriceLabel)
        }
        chatActionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(83)
        }
        albumButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(6)
            make.width.height.equalTo(38)
        }
        chatTextField.snp.makeConstraints { make in
            make.leading.equalTo(albumButton.snp.trailing).offset(4)
            make.centerY.equalTo(albumButton)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
        }
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(artDetailView.snp.bottom)
            make.bottom.equalTo(chatActionView.snp.top)
        }
    }
}
