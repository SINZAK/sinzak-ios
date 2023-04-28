//
//  ArtFullWidthCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class ArtFullWidthCVC: UICollectionViewCell {
    // MARK: - Properties
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "emptyRectangle")
    }
    private let favoriteBackground = UIView().then {
        $0.backgroundColor = CustomColor.gray80!.withAlphaComponent(0.4)
        $0.layer.cornerRadius = 16
    }
    let favoriteCountLabel = UILabel().then {
        $0.text = "1.3K"
        $0.font = .buttonText_R
        $0.textAlignment = .center
        $0.textColor = CustomColor.white
    }
    let favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: "favorite"), for: .normal) // 눌리면 "favorite-fill"
    }
    let titleLabel = UILabel().then {
        $0.textColor = CustomColor.black
        $0.font = .body_M
        $0.text = "작품명"
    }
    let labelStack = UIStackView().then {
        $0.spacing = 2
        $0.axis = .horizontal
    }
    let isDealing = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = false
        $0.image = UIImage(named: "isDealing")
    }
    let priceLabel = UILabel().then {
        $0.textColor = CustomColor.black
        $0.font = .body_B
        $0.text = "100,000원"
    }
    let authorLabel = UILabel().then {
        $0.textColor = CustomColor.black
        $0.font = .caption_R
        $0.text = "신작 작가"
    }
    private let middlePointLabel = UILabel().then {
        $0.textColor = CustomColor.black
        $0.font = .caption_M
        $0.text = " · "
    }
    let authorSchoolLabel = UILabel().then {
        $0.textColor = CustomColor.black
        $0.font = .caption_M
        $0.text = "홍익대"
    }
    let uploadTimeLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_M
        $0.text = "10시간 전"
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
            imageView, favoriteBackground,
            titleLabel, labelStack,
            authorLabel, middlePointLabel,
            authorSchoolLabel, uploadTimeLabel
        )
        labelStack.addArrangedSubviews(
            isDealing, priceLabel
        )
        favoriteBackground.addSubviews(
            favoriteButton, favoriteCountLabel
        )
    }
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(164.0)
        }
        favoriteBackground.snp.makeConstraints { make in
            make.trailing.equalTo(imageView).inset(12)
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.width.height.equalTo(35)
        }
        favoriteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(1)
            make.width.height.equalTo(17)
        }
        favoriteCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(favoriteButton.snp.bottom).offset(1)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView).inset(16)
            make.top.equalTo(imageView.snp.bottom).offset(12)
        }
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        isDealing.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(labelStack.snp.bottom).offset(5)
        }
        middlePointLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorLabel.snp.trailing)
            make.centerY.equalTo(authorLabel)
        }
        authorSchoolLabel.snp.makeConstraints { make in
            make.leading.equalTo(middlePointLabel.snp.trailing)
            make.centerY.equalTo(authorLabel)
        }
        uploadTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorLabel)
            make.trailing.equalTo(favoriteBackground)
        }
    }
}
