//
//  HomeHeader.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/13.
//

import UIKit

import Then
import SnapKit

final class HomeHeader: UICollectionReusableView {
    let titleLabel = UILabel().then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
       addSubview(titleLabel)
    }
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
    }
}
