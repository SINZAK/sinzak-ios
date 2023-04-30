//
//  WriteCategoryCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit

enum WriteCategoryColor {
    case base
    case selected
    var bgcolor: UIColor {
        switch self {
        case .base:
            return CustomColor.gray10
        case .selected:
            return CustomColor.red
        }
    }
    var fontColor: UIColor {
        switch self {
        case .base:
            return CustomColor.black
        case .selected:
            return CustomColor.white
        }
    }
}

final class WriteCategoryCVC: UICollectionViewCell {
    // MARK: - Properties
    private let baseView = UIView().then {
        $0.layer.cornerRadius = 25
        $0.backgroundColor = CustomColor.gray10
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let label = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.black
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
    // MARK: - Helper
    func setColor(kind: WriteCategoryColor) {
        baseView.backgroundColor = kind.bgcolor
        label.textColor = kind.fontColor
    }
    func updateCell(kind: WriteCategory) {
        label.text = kind.text
        imageView.image = UIImage(named: kind.image)
    }
    // MARK: - Design Helpers
    func setupUI() {
        contentView.addSubview(
            baseView
        )
        baseView.addSubviews(
            imageView, label
        )
    }
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(20)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.bottom.equalToSuperview().inset(16)
        }
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
