//
//  HomeView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/10.
//

import UIKit

class HomeView: SZView {
    // MARK: - Properties
    lazy var homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            homeCollectionView
        )
    }
    override func setLayout() {
        homeCollectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
    }
}
