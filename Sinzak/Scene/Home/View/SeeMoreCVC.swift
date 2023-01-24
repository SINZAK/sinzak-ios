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
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "moreCell")
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
            make.leading.top.equalToSuperview()
            make.width.equalTo(27)
            make.height.equalTo(163)
        }
    }
}
