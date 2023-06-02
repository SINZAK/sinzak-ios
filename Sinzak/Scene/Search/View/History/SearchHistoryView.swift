//
//  SearchHistoryView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit
import SnapKit
import Then

final class SearchHistoryView: SZView {
    // MARK: - Properties
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    private let titleLabel = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.gray60
        $0.text = "최근 검색어"
    }
    let removeAllButton = UIButton().then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(CustomColor.gray60, for: .normal)
        $0.titleLabel?.font = .caption_R
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            collectionView, titleLabel, removeAllButton
        )
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.top.equalTo(safeAreaLayoutGuide).inset(18)
        }
        removeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(64)
            make.height.equalTo(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
}
