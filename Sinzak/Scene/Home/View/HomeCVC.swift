//
//  HomeCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/13.
//

import UIKit
import SnapKit
import Then

final class HomeCVC: UICollectionViewCell {
    // MARK: - Properties
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
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
    }
    let authorLabel = UILabel().then {
        $0.textColor = CustomColor.black
        $0.font = .caption_R
        $0.text = "홍길동 작가"
    }
    let uploadTimeLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_M
        $0.text = "· 10시간 전"
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
            authorLabel, uploadTimeLabel
        )
        labelStack.addArangedSubviews(
            isDealing, priceLabel
        )
        favoriteBackground.addSubviews(
            favoriteButton, favoriteCountLabel
        )
    }
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        favoriteBackground.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView).inset(10)
            make.width.height.equalTo(32)
        }
        favoriteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(1)
            make.width.height.equalTo(16)
        }
        favoriteCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(favoriteButton.snp.bottom).offset(1)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(7)
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(7)
        }
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.lessThanOrEqualToSuperview().inset(7)
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
        uploadTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorLabel)
            make.leading.equalTo(authorLabel.snp.trailing)
            make.trailing.lessThanOrEqualToSuperview().inset(7)
        }
    }
}
