//
//  LeaveCVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/31.
//

import UIKit

final class LeaveCVC: UICollectionViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray80
        label.font = .body_M
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabel(name: String) {
        label.text = "\(name)님이 나가셨습니다."
    }
    
    private func setLayout() {
        backgroundColor = CustomColor.background
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(20.0)
        }
    }
}
