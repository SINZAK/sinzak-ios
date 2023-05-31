//
//  MyPostListCVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/17.
//

import UIKit

final class MyPostListCVC: UICollectionViewCell {
     
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.label
        label.font = .body_M
        
        return label
    }()
    
    private let uploadTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray60
        label.font = .caption_M
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.backgroundColor = .clear
    }
}

// MARK: - Configure Cell Method

extension MyPostListCVC {
    
    func configCell(products: Products) {
        if products.thumbnail?.isEmpty == false {
            let url = URL(string: products.thumbnail ?? "")
            imageView.kf.setImage(with: url)
        } else {
            Log.debug("없음")
            imageView.image = SZImage.Image.nothing
            imageView.backgroundColor = CustomColor.gray10
            imageView.contentMode = .center
        }
        
        titleLabel.text = products.title
        uploadTimeLabel.text = products.date.toDate().toRelativeString()
    }
}

// MARK: - Private Method

private extension MyPostListCVC {
    
    func configure() {
        configureCell()
        configLayout()
    }
    
    func configureCell() {
        backgroundColor = CustomColor.background
    }
    
    func configLayout() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            uploadTimeLabel
        )
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview()
            $0.height.equalTo(156.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        uploadTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.0)
            $0.trailing.equalToSuperview().inset(24.0)
        }
    }
}
