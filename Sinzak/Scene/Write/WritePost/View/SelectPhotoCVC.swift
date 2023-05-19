//
//  SelectPhotoCVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/18.
//

import UIKit

final class SelectPhotoCVC: UICollectionViewCell {
    
    // MARK: - UI
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1.0
        view.layer.borderColor = CustomColor.label.cgColor
        view.layer.cornerRadius = 12.0
        view.clipsToBounds = true
        
        return view
    }()
    
    private let cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = SZImage.Icon.camera
        
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .caption_M
        label.textColor = CustomColor.label
        label.text = "0"
        
        return label
    }()
    
    private let maxCountLabel: UILabel = {
        let label = UILabel()
        label.font = .caption_M
        label.textColor = CustomColor.label
        label.text = " / 5"
        
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 0.0
        
        return stack
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCountLabel(count: Int) {
        countLabel.text = "\(count)"
        countLabel.textColor = count == 0 ? CustomColor.label : CustomColor.red50
    }
}

// MARK: - Private Method

private extension SelectPhotoCVC {
    
    func configureLayout() {
        
        labelStackView.addArrangedSubviews(
            countLabel,
            maxCountLabel
        )
        
        containerView.addSubviews(
            cameraImageView,
            labelStackView
        )
        
        addSubviews(
            containerView
        )
        
        containerView.snp.makeConstraints {
            $0.height.width.equalTo(72.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.centerX.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(cameraImageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
}
