//
//  HomeBannerCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/13.
//

import UIKit
import SnapKit
import Then

final class HomeBannerCVC: UICollectionViewCell {
    // MARK: - Properties
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
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
    // MARK: - Design Helper
    func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
    }
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(0.39)
        }
    }
}
