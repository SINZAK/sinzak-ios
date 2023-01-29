//
//  WorksHeader.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/29.
//

import UIKit
import SnapKit
import Then

class WorksHeader: UICollectionReusableView {
    let requestTabButton = UIButton().then {
        $0.setTitle("의뢰해요", for: .normal)
        $0.titleLabel?.font = .body_B
        $0.setTitleColor(CustomColor.black, for: .normal)
    }
    let WorkTabButton = UIButton().then {
        $0.setTitle("작업해요", for: .normal)
        $0.titleLabel?.font = .body_B
        $0.setTitleColor(CustomColor.gray60, for: .normal)
    }
    let selectBar = UIView().then {
        $0.backgroundColor = CustomColor.black
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
            requestTabButton, WorkTabButton,
            selectBar, alignButton
        )
    }
    func setConstraints() {
        requestTabButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(42)
        }
        WorkTabButton.snp.makeConstraints { make in
            make.leading.equalTo(requestTabButton.snp.trailing)
            make.centerY.equalTo(requestTabButton)
            make.height.equalTo(42)
        }
        selectBar.snp.makeConstraints { make in
            make.top.width.equalTo(requestTabButton.snp.bottom)
            make.height.equalTo(2)
        }
        alignButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
    }

}
