//
//  MyImageCVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/31.
//

import UIKit
import Kingfisher

final class MyImageCVC: UICollectionViewCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(url: String) {
        let url = URL(string: url)
        imageView.kf.setImage(with: url)
    }
    
    private func setLayout() {
        backgroundColor = CustomColor.background
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.width.equalTo(frame.width / 2.0)
            $0.height.equalTo(frame.width / 2.0)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20.0)
        }
    }
}
