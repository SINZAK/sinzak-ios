//
//  ArtCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/13.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import SkeletonView

final class ArtCVC: UICollectionViewCell {
    // MARK: - Properties
    
    var products: Products?
    
    private let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "emptySquare")
        $0.isSkeletonable = true
    }
    private let favoriteBackground = UIView().then {
        $0.backgroundColor = CustomColor.onlyGray80!.withAlphaComponent(0.4)
        $0.layer.cornerRadius = 16
    }
    private let favoriteCountLabel = UILabel().then {
        $0.text = "1.3K"
        $0.font = .buttonText_R
        $0.textAlignment = .center
        $0.textColor = CustomColor.white
    }
    private let favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: "favorite"), for: .normal) // 눌리면 "favorite-fill"
    }
    private let titleLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .body_M
        $0.text = "Flower Garden"
        $0.isSkeletonable = true

    }
    private let labelStack = UIStackView().then {
        $0.spacing = 2
        $0.axis = .horizontal
        $0.isSkeletonable = true
    }
    private let isDealing = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.image = UIImage(named: "isDealing")
    }
    private let priceLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .body_B
        $0.text = "33,000원"
        $0.isSkeletonable = true

    }
    private let authorLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .caption_R
        $0.text = "신작 작가"
        $0.isSkeletonable = true
    }
    private let middlePointLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_M
        $0.text = "· "
    }
    private let uploadTimeLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_M
        $0.text = "10시간 전"
        $0.isSkeletonable = true
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
        isSkeletonable = true
        contentView.isSkeletonable = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setter
    func setData(_ data: Products) {
        
        self.products = data
        
        if let thumbnail = data.thumbnail {
            let url = URL(string: thumbnail)
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = data.title
        authorLabel.text = data.author
        uploadTimeLabel.text = data.date.toDate().toRelativeString()
        priceLabel.text = "\(data.price)"
        favoriteCountLabel.text = "\(data.likesCnt)"
    }
    
    func setData(_ data: MarketProduct) {
        let url = URL(string: data.thumbnail)
        imageView.kf.setImage(with: url)
        titleLabel.text = data.title
        authorLabel.text = data.author
        uploadTimeLabel.text = data.date.toDate().toRelativeString()
        priceLabel.text = "\(data.price)"
        favoriteCountLabel.text = "\(data.likesCnt)"
    }
    
    func setSkeleton() {
        favoriteBackground.isHidden = true
        favoriteButton.isHidden = true
        favoriteCountLabel.isHidden = true
        middlePointLabel.isHidden = true
        uploadTimeLabel.isHidden = true
    }
    // MARK: - Design Helpers
    func setupUI() {
        contentView.isSkeletonable = true
        contentView.backgroundColor = .clear
        contentView.addSubviews(
            imageView, favoriteBackground,
            titleLabel, labelStack,
            authorLabel, middlePointLabel, uploadTimeLabel
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
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
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
        middlePointLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorLabel)
            make.leading.equalTo(authorLabel.snp.trailing)
        }
        uploadTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(middlePointLabel)
            make.leading.equalTo(middlePointLabel.snp.trailing)
            make.trailing.lessThanOrEqualToSuperview().inset(7)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        uploadTimeLabel.text = nil
        priceLabel.text = nil
        favoriteCountLabel.text = nil
    }
}
