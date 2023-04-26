//
//  HomeView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/10.
//

import UIKit

class HomeView: SZView {
    // MARK: - Properties
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = CustomColor.refreshControl
        
        return refreshControl
    }()
    
    lazy var homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.refreshControl = refreshControl
        $0.backgroundColor = .clear
        $0.register(
            BannerCVC.self,
            forCellWithReuseIdentifier: BannerCVC.identifier
        )
        $0.register(
            BannerFooter.self,
            forSupplementaryViewOfKind: "footer",
            withReuseIdentifier: BannerFooter.identifier
        )
        $0.register(
            HomeHeader.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: HomeHeader.identifier
        )
        $0.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )
        $0.register(
            HomeCategoryCVC.self,
            forCellWithReuseIdentifier: HomeCategoryCVC.identifier
        )
        $0.register(
            SeeMoreCVC.self,
            forCellWithReuseIdentifier: SeeMoreCVC.identifier
        )
    }
    
    lazy var skeletonView = HomeSkeletonView()

    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            homeCollectionView,
            skeletonView
        )
    }
    override func setLayout() {
        homeCollectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        skeletonView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(homeCollectionView.snp.top)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
