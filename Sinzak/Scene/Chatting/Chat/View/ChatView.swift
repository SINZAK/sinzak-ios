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
        $0.register(MyImageCVC.self,
                    forCellWithReuseIdentifier: MyImageCVC.identifier)
        $0.register(OtherImageCVC.self,
                    forCellWithReuseIdentifier: OtherImageCVC.identifier)
        $0.register(LeaveCVC.self,
                    forCellWithReuseIdentifier: LeaveCVC.identifier)
        $0.backgroundColor = .clear
    }
    // 상단 작품디테일쪽
    let artDetailView = UIView().then {
        $0.backgroundColor = CustomColor.background
    }
    let artThumbnail = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
    }
    let isDealingLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .caption_B
    }
    let artTitleLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .caption_R
    }
    let artPriceLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .caption_R
    }
    let isNotNegotiableButton = UIButton().then {
        $0.setTitleColor(CustomColor.gray60, for: .normal)
        $0.titleLabel?.font = .caption_R
        $0.isUserInteractionEnabled = false
    // TODO: 보류
        $0.isHidden = true
    }
    let isNegotiableButton = UIButton().then {
//        $0.setTitle("가격제안하기", for: .normal)
        $0.titleLabel?.font = .caption_M
        $0.isHidden = true
        $0.setTitleColor(CustomColor.purple, for: .normal)
    }
    // 하단 채팅레이블쪽
    let chatActionView = UIView().then {
        $0.backgroundColor = CustomColor.background
    }
    let albumButton = UIButton().then {
        $0.setImage(UIImage(named: "album"), for: .normal)
    }
    let chatTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)).then {
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 21
        $0.font = .body_R
        $0.textColor = CustomColor.label
        $0.clearButtonMode = .never
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50.0)
        }
        albumButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
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
            make.top.equalTo(artDetailView.snp.bottom).offset(4.0)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-44.0)
        }
    }
}

extension ChatView {
    
    func setArtDetailInfo(info: ChatRoomInfo) {
        let url = URL(string: info.thumbnail)
        artThumbnail.kf.setImage(with: url)
        isDealingLabel.text = info.complete ? "거래 완료" : "거래중"
        artTitleLabel.text = info.postName
        artPriceLabel.text = info.price.toMoenyFormat()
        
        // TODO: 보류
        isNotNegotiableButton.isHidden = true
    }
    
    func setLeaveMode() {
        albumButton.isEnabled = false
        chatTextField.isEnabled = false
        chatTextField.placeholder = "메시지를 보낼 수 없습니다."
    }
}

// MARK: - Remake Constraits

extension ChatView {
    
    func setShowKeyboardLayout(height: CGFloat, maxY: CGFloat) {
        chatActionView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(height)
            make.height.equalTo(44.0)
        }
        
        collectionView.contentInset.bottom = height - safeAreaInsets.bottom
        collectionView.verticalScrollIndicatorInsets.bottom = collectionView.contentInset.bottom
        
        let cellY = collectionView.frame.height - maxY + 44.0 + safeAreaInsets.bottom
        
        if cellY > height + 50.0 {
            return
        }
        
        collectionView.contentOffset.y += height - safeAreaInsets.bottom - max(collectionView.frame.height - maxY, 0)
    }
    
    func setHideKeyboardLayout() {
        chatActionView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44.0)
        }
        
        collectionView.contentInset.bottom = 0
        collectionView.verticalScrollIndicatorInsets.bottom = collectionView.contentInset.bottom
    }
}
