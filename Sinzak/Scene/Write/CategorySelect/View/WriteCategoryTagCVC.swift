//
//  WriteCategoryTagCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class WriteCategoryTagCVC: UICollectionViewCell {
    let checkIcon = UIImageView().then {
        $0.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = CustomColor.black
    }
    let categoryLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.black
        $0.textAlignment = .right
        $0.text = "전체"
    }
    let tagBackgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.backgroundColor = CustomColor.gray10
    }
    // MARK: - Init
    func setColor(kind: WriteCategoryColor) {
        checkIcon.tintColor = kind.fontColor
        categoryLabel.textColor = kind.fontColor
        tagBackgroundView.backgroundColor = kind.bgcolor
    }
    func updateCell(kind: CategoryType) {
        categoryLabel.text = kind.text
    }
    func updateCell(kind: WorksCategory) {
        categoryLabel.text = kind.text
    }
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
        contentView.addSubviews(
            tagBackgroundView, checkIcon, categoryLabel
        )
    }
    func setConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(9)
        }
        checkIcon.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.width.height.equalTo(20)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(categoryLabel.snp.leading).offset(-2)
        }
        tagBackgroundView.snp.makeConstraints { make in
            make.leading.equalTo(checkIcon).offset(-8)
            make.top.equalTo(categoryLabel).offset(-9)
            make.bottom.equalTo(categoryLabel).offset(9)
            make.trailing.equalTo(categoryLabel).offset(15)
        }
    }
}
