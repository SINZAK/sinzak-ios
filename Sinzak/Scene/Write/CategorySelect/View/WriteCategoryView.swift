//
//  WriteCategoryView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit
import SnapKit
import Then

final class WriteCategoryView: SZView {
    // MARK: - Properties
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.alwaysBounceVertical = false
        $0.backgroundColor = .clear
        $0.register(
            WriteCategoryCVC.self,
            forCellWithReuseIdentifier: WriteCategoryCVC.identifier
        )
        $0.register(
            WriteCategoryHeader.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: WriteCategoryHeader.identifier
        )
    }
    
    let genreCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.alwaysBounceVertical = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            InterestedGenreCVC.self,
            forCellWithReuseIdentifier: InterestedGenreCVC.identifier
        )
        collectionView.register(
            WriteCategoryHeader.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: WriteCategoryHeader.identifier
        )
        
        return collectionView
    }()
    
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            categoryCollectionView,
            genreCollectionView
        )
    }
    override func setLayout() {
        categoryCollectionView.collectionViewLayout = setCategoryCollectionViewLayout()
        genreCollectionView.collectionViewLayout = setGenreCollectionViewLayout()

        categoryCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(48.0 + 16.0 + 100.0)
        }
        
        genreCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryCollectionView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
}

// 컴포지셔널 레이아웃
private extension WriteCategoryView {
    /// 컴포지셔널 레이아웃 세팅
    
    func setCategoryCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(100.0),
                heightDimension: .absolute(100.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            let inset = (UIScreen.main.bounds.width - 100.0 * 3 - 4.0 * 2) / 2
            group.interItemSpacing = .fixed(4.0)
            group.contentInsets.leading = inset
            group.contentInsets.trailing = inset
            
            let section = NSCollectionLayoutSection(group: group)
            
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(48.0)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: "header",
                alignment: .top
            )
            
            headerItem.contentInsets.leading = 20.0
            section.boundarySupplementaryItems = [headerItem]
            section.contentInsets.top = 16.0
            
            return section
        }
    }
    
    func setGenreCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {_, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(70),
                heightDimension: .absolute(30.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(400))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10.0)
            group.contentInsets.leading = 40.0
            group.contentInsets.trailing = 40.0
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.top = 16.0
            section.interGroupSpacing = 12.0
            
            // 헤더 설정
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(56.0 + 18.0)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: "header",
                alignment: .top
            )
            
            headerItem.contentInsets.leading = 20.0

            section.boundarySupplementaryItems = [headerItem]
            return section
        }
    }
}
