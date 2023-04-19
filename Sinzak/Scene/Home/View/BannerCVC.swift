//
//  BannerCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/13.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class BannerCVC: UICollectionViewCell {
    // MARK: - Properties
    let imageView = UIImageView().then {
        $0.isSkeletonable = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
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
    // MARK: - SetData
    func setData(banner: Banner) {
        let url = URL(string: banner.imageURL)
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "banner"),
                              options: [.cacheOriginalImage],
                              completionHandler: nil)
    }
    // MARK: - Design Helper
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
    }
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(0.39)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
