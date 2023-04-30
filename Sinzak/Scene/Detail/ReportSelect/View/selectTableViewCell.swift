//
//  selectTableViewCell.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/30.
//

import UIKit

final class SelectTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.label
        label.font = .body_M
        label.text = "전문 판매업자 같아요"
        
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moreCell")?
            .withTintColor(
                CustomColor.gray60,
                renderingMode: .alwaysOriginal
            )
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        self.label.text = title
    }
    
    private func configureLayout() {
        backgroundColor = CustomColor.background
        addSubviews(
            label,
            iconView
        )
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(32.0)
            $0.centerY.equalToSuperview()
        }
        
        iconView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(32.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24.0)
        }
    }
}
