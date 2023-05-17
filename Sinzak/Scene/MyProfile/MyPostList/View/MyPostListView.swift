//
//  MyPostListView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/17.
//

import UIKit

final class MyPostListView: SZView {
    
    let productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(
            MyPostListCVC.self,
            forCellWithReuseIdentifier: MyPostListCVC.identifier
        )
        $0.backgroundColor = .clear
    }
    
    let nothingView: NothingView = {
        let view = NothingView()
        view.label.text = ""
        
        return view
    }()
        
    override func setView() {
        nothingView.isHidden = true
        
        addSubviews(
            productCollectionView,
            nothingView
        )
    }
    
    override func setLayout() {
        productCollectionView.collectionViewLayout = setProductLayout()
        
        productCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        nothingView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(196.0)
            $0.centerX.equalToSuperview()
        }
    }
}

private extension MyPostListView {
    
    func setProductLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(244.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets.bottom = 20
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.top = 16.0
            section.contentInsets.bottom = 72
            
            return section
        }
    }
}
