//
//  CategoryTagCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/27.
//

import UIKit
import SnapKit
import Then
import SkeletonView

enum ColorKind {
    case base
    case selected
    var color: UIColor {
        switch self {
        case .base:
            return CustomColor.gray60
        case .selected:
            return CustomColor.red
        }
    }
}

final class CategoryTagCVC: UICollectionViewCell {
    
    // MARK: - Property
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                setColor(kind: .selected)
            } else {
                setColor(kind: .base)
            }
        }
    }
    
    var category: ProductsCategory?
    var worksCategory: WorksCategory?
    
    // MARK: - UI
    
    let checkIcon = UIImageView().then {
        $0.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = CustomColor.gray60
        $0.isSkeletonable = true
    }
    let categoryLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.gray60
        $0.textAlignment = .right
        $0.text = "회화일"
        $0.isSkeletonable = true
    }
    let tagBackgroundView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.backgroundColor = CustomColor.background
        $0.layer.borderWidth = 1
        $0.layer.borderColor = CustomColor.gray60.cgColor
        $0.isSkeletonable = true
    }
    
    func setColor(kind: ColorKind) {
        let color = kind.color
        checkIcon.tintColor = color
        categoryLabel.textColor = color
        tagBackgroundView.layer.borderColor = color.cgColor
    }
    
    func updateProductsCell(category: ProductsCategory) {
        self.category = category
        categoryLabel.text = category.text
    }
    
    func updateWorksCell(category: WorksCategory) {
        worksCategory = category
        categoryLabel.text = category.text
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

    // MARK: - UI
    private func setupUI() {
        contentView.addSubviews(
            tagBackgroundView, checkIcon, categoryLabel
        )
        self.contentView.isSkeletonable = true
    }
    
    private func setConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
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
            make.height.equalTo(32.0)
            make.trailing.equalTo(categoryLabel).offset(15)
        }
    }
}
