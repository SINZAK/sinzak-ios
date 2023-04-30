//
//  SeeMoreCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class SeeMoreCVC: UICollectionViewCell {
    // MARK: - Properties

    var alignOption: AlignOption? {
        willSet {
            guard let newValue = newValue else { return }
            if newValue == .popular && UserInfoManager.isLoggedIn {
                imageView.image = nil
            } else {
                imageView.image = UIImage(named: "moreCell")?
                    .withTintColor(CustomColor.label, renderingMode: .alwaysOriginal)
            }
        }
    }
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "moreCell")?
            .withTintColor(CustomColor.label, renderingMode: .alwaysOriginal)
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
            make.leading.equalToSuperview()
            make.top.equalToSuperview().inset(164/2 - 24/2)
            make.width.height.equalTo(24.0)
        }
    }
}
