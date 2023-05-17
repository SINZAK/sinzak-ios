//
//  SelectIconCVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/11.
//

import UIKit

final class SelectIconCVC: UICollectionViewCell {
    
    override var isSelected: Bool {
        willSet {
            switch newValue {
            case true:
                imageView.layer.borderColor = CustomColor.red.cgColor
                imageView.layer.borderWidth = 2.0
                
            case false:
                imageView.layer.borderColor = CustomColor.gray40.cgColor
                
            }
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = CustomColor.gray40.cgColor
        imageView.layer.cornerRadius = 30.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configImage(with image: UIImage?) {
        imageView.image = image
    }
}

private extension SelectIconCVC {
    
    func configLayout() {
        backgroundColor = CustomColor.background
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
