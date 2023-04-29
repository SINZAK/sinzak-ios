//
//  ProductsDetailSkeletonView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/29.
//

import UIKit

final class ProductsDetailSkeletonView: SZView {
    
    let imageView: UIImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀타이틀타이틀타이틀타이틀타이틀"
        label.isSkeletonable = true
        
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리카테고리"
        label.isSkeletonable = true
        
        return label
    }()
    
    let moneyLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀타이틀타이틀타이틀타이틀타이틀"
        label.isSkeletonable = true

        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리카테고리"
        label.isSkeletonable = true

        return label
    }()
    
    let authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍익대학교verified 팔로워 25"
        label.isSkeletonable = true

        return label
    }()
    
    let followLabel: UILabel = {
        let label = UILabel()
        label.text = "홍익대학교verified 팔로워 25"
        label.isSkeletonable = true

        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16.0
        button.isSkeletonable = true
        button.clipsToBounds = true
        
        return button
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.text = "상세 사이즈"
        label.isSkeletonable = true

        return label
    }()

    let widthLabel: UILabel = {
        let label = UILabel()
        label.text = "상세 사이즈"
        label.isSkeletonable = true

        return label
    }()
    
    let verticalLabel: UILabel = {
        let label = UILabel()
        label.text = "상세 사이즈상세 사이즈상세 사이즈상세 사이즈상세 사이즈사이즈사이즈사이즈사이즈사이즈"
        label.isSkeletonable = true

        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "상세 사이즈상세 사이즈상세 사이즈상세 사이즈상세 사이즈사이즈사이즈사이즈사이즈사이즈"
        label.isSkeletonable = true

        return label
    }()
    
    override func setView() {
        isSkeletonable = true
    }
    
    override func setLayout() {
        imageView.isSkeletonable = true
        authorImageView.isSkeletonable = true
        
        addSubviews(
            imageView,
            titleLabel, categoryLabel,
            moneyLabel, timeLabel,
            authorImageView, nameLabel, followLabel, button,
            sizeLabel, widthLabel, verticalLabel, heightLabel
        )
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
        
        moneyLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(moneyLabel)
        }
        
        authorImageView.snp.makeConstraints {
            $0.width.height.equalTo(42.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(moneyLabel.snp.bottom).offset(36.0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(authorImageView)
            $0.leading.equalTo(authorImageView.snp.trailing).offset(8.0)
        }
        
        followLabel.snp.makeConstraints {
            $0.bottom.equalTo(authorImageView)
            $0.leading.equalTo(nameLabel)
        }
        
        button.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(32.0)
            $0.width.equalTo(64.0)
            $0.centerY.equalTo(authorImageView)
        }
        
        sizeLabel.snp.makeConstraints {
            $0.top.equalTo(authorImageView.snp.bottom).offset(36.0)
            $0.leading.equalToSuperview().inset(24.0)
        }
        
        widthLabel.snp.makeConstraints {
            $0.top.equalTo(sizeLabel.snp.bottom).offset(14.0)
            $0.leading.equalToSuperview().inset(48.0)
            $0.trailing.equalToSuperview()
        }
        
        verticalLabel.snp.makeConstraints {
            $0.top.equalTo(widthLabel.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().inset(48.0)
            $0.trailing.equalToSuperview()
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(verticalLabel.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().inset(48.0)
            $0.trailing.equalToSuperview()
        }
    }
}
