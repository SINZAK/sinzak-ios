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
    
    lazy var homeProductSekeletoneCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.isHidden = true
        collectionView.register(
            BannerCVC.self,
            forCellWithReuseIdentifier: BannerCVC.identifier
        )
        collectionView.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )
        collectionView.register(
            HomeHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeader.identifier
        )

        return collectionView
    }()

    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            homeCollectionView,
            homeProductSekeletoneCollectionView
        )
    }
    override func setLayout() {
        homeCollectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        homeProductSekeletoneCollectionView.snp.makeConstraints {
            $0.edges.equalTo(homeCollectionView)
        }
    }
}
