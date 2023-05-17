//
//  ScrapListView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/17.
//

import UIKit

final class ScrapListView: SZView {
    
    let productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )
        $0.backgroundColor = .clear
    }
    
    let nothingView = NothingView()
    
    let marketSkeletonView: MarketSkeletonView = MarketSkeletonView()
    
    override func setView() {
        marketSkeletonView.isHidden = true
        nothingView.isHidden = true
        
        addSubviews(
            productCollectionView,
            nothingView,
            marketSkeletonView
        )
    }
    
    override func setLayout() {
        productCollectionView.collectionViewLayout = setProductLayout()
        
        productCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        marketSkeletonView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        marketSkeletonView
            .productCollectionView.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        
        nothingView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(196.0)
            $0.centerX.equalToSuperview()
        }
    }
}

private extension ScrapListView {
    
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
