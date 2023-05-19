//
//  WritePostView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class WritePostView: SZView {
    // MARK: - Properties

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.alwaysBounceVertical = false
        $0.backgroundColor = .clear
        $0.register(
            SelectPhotoCVC.self,
            forCellWithReuseIdentifier: SelectPhotoCVC.identifier
        )
        $0.register(
            SelectedPhotoCVC.self,
            forCellWithReuseIdentifier: SelectedPhotoCVC.identifier
        )
    }

    // MARK: - Design Helpers
    override func setView() {
        addSubviews(

            collectionView
    
        )
    }
    override func setLayout() {
        collectionView.collectionViewLayout = setLayout()
    
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(16.0)
            make.height.equalTo(132.0)
        }
    }
}

// 컴포지셔널 레이아웃
private extension WritePostView {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(72.0),
                heightDimension: .estimated(100.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets.bottom = 4.0
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2.0),
                heightDimension: .estimated(132.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 16
            section.interGroupSpacing = 0
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
}
