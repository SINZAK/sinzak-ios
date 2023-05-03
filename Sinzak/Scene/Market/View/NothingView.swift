//
//  NothingView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/03.
//

import UIKit

final class NothingView: SZView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "nothing")?
            .withTintColor(
                CustomColor.gray60,
                renderingMode: .alwaysOriginal
            )
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없어요"
        label.textColor = CustomColor.gray60
        label.font = .body_B
        
        return label
    }()
    
    override func setLayout() {
        addSubviews(
            imageView,
            label
        )
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(98.0)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(2.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}
