//
//  NotificationCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class NotificationCVC: UICollectionViewCell {
    // MARK: - Properties
    let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "notiThumb")
    }
    let titleLabel = UILabel().then {
        $0.text = "sinzak 님이 작품 ‘환상'에 가격 제안을 했어요. [24,000원]"
        $0.font = .body_M
        $0.textColor = CustomColor.black
        $0.numberOfLines = 0
    }
    let timeLabel = UILabel().then {
        $0.text = "방금 전"
        $0.font = .caption_R
        $0.textColor = CustomColor.gray80
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
            thumbnailImageView, titleLabel, timeLabel
        )
    }
    func setConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().inset(17)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(17)
        }
    }
}
