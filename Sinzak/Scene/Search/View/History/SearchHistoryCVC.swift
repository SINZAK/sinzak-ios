//
//  SearchHistoryCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit
import SnapKit
import Then

final class SearchHistoryCVC: UICollectionViewCell {
    // MARK: - Properties
    let queryLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.black
        $0.text = "쿼리"
    }
//    let removeButton = UIButton().then {
//        $0.tintColor = CustomColor.gray60
//        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
//    }
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
        contentView.addSubviews(
            queryLabel // , removeButton
        )
    }
    func setConstraints() {
        queryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.bottom.equalToSuperview().inset(16)
        }
//        removeButton.snp.makeConstraints { make in
//            make.centerY.equalTo(queryLabel)
//            make.width.height.equalTo(24)
//            make.trailing.equalToSuperview().inset(24)
//        }
    }
}
