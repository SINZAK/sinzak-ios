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
    
    let homeSekeletoneCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            homeCollectionView,
            homeSekeletoneCollectionView
        )
    }
    override func setLayout() {
        homeCollectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        homeSekeletoneCollectionView.snp.makeConstraints {
            $0.edges.equalTo(homeCollectionView)
        }
    }
}
