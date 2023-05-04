//
//  WorksView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/04.
//

import UIKit
import SnapKit
import Then
import SkeletonView

final class WorksView: SZView {
    // MARK: - Properties
    lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.alwaysBounceVertical = false
        $0.showsVerticalScrollIndicator = false
        $0.register(
            CategoryTagCVC.self,
            forCellWithReuseIdentifier: CategoryTagCVC.identifier
        )
        $0.collectionViewLayout = setCategoryLayout()
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = true
    }
    
    lazy var worksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = CustomColor.black
        $0.refreshControl = refreshControl
        $0.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )
        $0.collectionViewLayout = setProductLayout()
        $0.backgroundColor = .clear
    }
    
    let writeButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 31
        $0.backgroundColor = CustomColor.red
        $0.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    let nothingView = NothingView()
    
    let marketSkeletonView: MarketSkeletonView = MarketSkeletonView()
    
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            categoryCollectionView,
            worksCollectionView, writeButton,
            nothingView,
            marketSkeletonView
        )
    }
    
    override func setLayout() {
        
        categoryCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(56.0)
        }
        
        worksCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(62)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(7)
            make.trailing.equalToSuperview().inset(11)
        }
        
        nothingView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(196.0)
            $0.centerX.equalToSuperview()
        }
        
        marketSkeletonView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        marketSkeletonView
            .productCollectionView.snp.makeConstraints {
                $0.trailing.leading.equalToSuperview()
                $0.top.equalTo(categoryCollectionView.snp.bottom)
                $0.bottom.equalTo(safeAreaLayoutGuide)
            }
    }
}

// MARK: - 컴포지셔널 레이아웃
extension WorksView {
    
    func setCategoryLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(70.0),
                heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2.5),
                heightDimension: .absolute(32.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets.top = 12.0
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 16.0
            section.contentInsets.bottom = 16.0
            section.interGroupSpacing = 0
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
    
    func setProductLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(264)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets.leading = 8
            item.contentInsets.trailing = 8
            item.contentInsets.bottom = 16
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.top = 0
            section.contentInsets.leading = 8
            section.contentInsets.trailing = 8
            section.contentInsets.bottom = 72
            
            return section
        }
    }
}
