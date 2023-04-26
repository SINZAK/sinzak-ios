//
//  SoldOutView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/26.
//

import UIKit

final class SoldOutView: UIView {
    
    var kind: ArtCellKind? {
        willSet {
            guard let newValue = newValue else { return }
            
            switch newValue {
            case .products:
                infoLabel.text = "판매완료"
            case .work:
                infoLabel.text = "모집완료"
            }
        }
    }
    
    // MARK: - UI
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check-circle-default")?.withTintColor(.white)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .body_B
        label.textColor = .white
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.isHidden = true
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        backgroundColor = .black.withAlphaComponent(0.4)
        
        addSubviews(checkImageView, infoLabel)
        
        checkImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(56.0)
            $0.width.height.equalTo(32.0)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(checkImageView.snp.bottom)
        }
    }
    
}
