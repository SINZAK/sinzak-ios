//
//  MarketHeader.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/29.
//

import UIKit
import SnapKit
import Then

class MarketHeader: UICollectionReusableView {

    let viewOptionButton = UIButton().then {
        $0.setImage(UIImage(named: "radiobtn-unchecked"), for: .normal)
        $0.setTitle("판매중 작품만 보기", for: .normal)
        $0.titleLabel?.font = .caption_M
        $0.setTitleColor(CustomColor.gray80, for: .normal)
        $0.tintColor = CustomColor.gray80
    }
    let alignButton = UIButton().then {
        $0.setImage(UIImage(named: "align"), for: .normal)
        $0.setTitle("신작추천순", for: .normal)
        $0.titleLabel?.font = .caption_B
        $0.setTitleColor(CustomColor.gray80, for: .normal)
        $0.tintColor = CustomColor.gray80
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
        addSubviews(
            viewOptionButton,
            alignButton
        )
    }
    func setConstraints() {
        viewOptionButton.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.equalToSuperview()
        }
        alignButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalTo(22)
        }
    }

}
