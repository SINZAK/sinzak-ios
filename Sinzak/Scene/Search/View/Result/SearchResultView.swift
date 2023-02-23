//
//  SearchResultView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/14.
//

import UIKit
import SnapKit
import Then

final class SearchResultView: SZView {
    // MARK: - Properties
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubview(
            collectionView
        )
    }
    override func setLayout() {
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
    }
}
