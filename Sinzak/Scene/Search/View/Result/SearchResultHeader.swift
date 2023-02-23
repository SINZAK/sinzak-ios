//
//  SearchResultHeader.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit
import SnapKit
import Then

final class SearchResultHeader: UICollectionReusableView {
    // MARK: - Properties
    let stackView = UIStackView().then {
        $0.spacing = 0
        $0.distribution = .equalCentering
        $0.axis = .horizontal
    }
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
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Design Helpers
    func setupUI() {
        addSubviews(
            stackView,
            selectBar
        )
        stackView.addArrangedSubviews(
            requestTabButton, WorkTabButton
        )
    }
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        requestTabButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(72)
            make.height.equalTo(42)
        }
        WorkTabButton.snp.makeConstraints { make in
            make.leading.equalTo(requestTabButton.snp.trailing).offset(4)
            make.width.equalTo(72)
            make.centerY.equalTo(requestTabButton)
            make.height.equalTo(42)
        }
        selectBar.snp.makeConstraints { make in
            make.top.equalTo(requestTabButton.snp.bottom)
            make.leading.trailing.equalTo(requestTabButton)
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
    }

}
