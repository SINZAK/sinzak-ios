//
//  MyChatBubbleCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class MyChatBubbleCVC: UICollectionViewCell {
    let dateLabel = UILabel().then {
        $0.font = .buttonText_R
        $0.textColor = CustomColor.gray80
        $0.textAlignment = .right
    }
    let chatLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.white
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
    let bubbleBackgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 21
        $0.backgroundColor = CustomColor.red
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
        bubbleBackgroundView.addSubview(chatLabel)
        contentView.addSubview(bubbleBackgroundView)
        contentView.addSubview(dateLabel)
    }
    func setConstraints() {
        chatLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16.0)
            make.top.bottom.equalToSuperview().inset(12.0)
            make.width.lessThanOrEqualTo(frame.width * (2/3))
        }
        bubbleBackgroundView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16.0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(2.0)
            make.leading.equalTo(chatLabel.snp.leading).offset(-16.0)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bubbleBackgroundView)
            make.trailing.equalTo(bubbleBackgroundView.snp.leading).offset(-4.0)
        }
    }
}
