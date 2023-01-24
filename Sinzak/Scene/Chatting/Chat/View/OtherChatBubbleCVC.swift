//
//  OtherChatBubbleCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class OtherChatBubbleCVC: UICollectionViewCell {
    let dateLabel = UILabel().then {
        $0.font = .buttonText_R
        $0.textColor = CustomColor.gray80
        $0.textAlignment = .left
    }
    let chatLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    let bubbleBackgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 21
        $0.backgroundColor = CustomColor.gray10
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
    // MARK: - UI
    func setupUI() {
        contentView.addSubview(bubbleBackgroundView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(chatLabel)
    }
    func setConstraints() {
        chatLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(34)
            make.trailing.lessThanOrEqualToSuperview().inset(72)
            make.top.bottom.equalToSuperview().inset(18)
        }
        bubbleBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(chatLabel).offset(12)
            make.trailing.equalTo(chatLabel).offset(18)
            make.leading.equalTo(chatLabel).offset(-18)
            make.top.equalTo(chatLabel).offset(-12)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bubbleBackgroundView)
            make.leading.equalTo(bubbleBackgroundView.snp.trailing)
        }
    }
}
