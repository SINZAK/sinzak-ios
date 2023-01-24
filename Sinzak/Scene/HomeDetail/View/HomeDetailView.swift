//
//  HomeDetailView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class HomeDetailView: SZView {
    // MARK: - Properties
    lazy var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            detailCollectionView
        )
    }
    override func setLayout() {
        detailCollectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
    }
}
