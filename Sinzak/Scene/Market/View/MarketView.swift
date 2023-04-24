//
//  MarketView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then
import SkeletonView

final class MarketView: SZView {
    // MARK: - Properties
    lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(
            CategoryTagCVC.self,
            forCellWithReuseIdentifier: CategoryTagCVC.identifier
        )
        $0.collectionViewLayout = setCategoryLayout()
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = true
        $0.isSkeletonable = true
    }
    
    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )
        $0.collectionViewLayout = setProductLayout()
        $0.allowsMultipleSelection = true
        $0.backgroundColor = .clear
        $0.isSkeletonable = true
    }
    
    let viewOptionButton = UIButton().then {
        $0.setImage(UIImage(named: "radiobtn-unchecked"), for: .normal)
        $0.setTitle("판매중 작품만 보기", for: .normal)
        $0.titleLabel?.font = .caption_M
        $0.setTitleColor(CustomColor.gray80, for: .normal)
        $0.tintColor = CustomColor.gray80
        $0.isSkeletonable = true
    }
    
    let alignButton = UIButton().then {
        $0.setImage(UIImage(named: "align"), for: .normal)
        $0.setTitle("신작추천순", for: .normal)
        $0.titleLabel?.font = .caption_B
        $0.setTitleColor(CustomColor.gray80, for: .normal)
        $0.tintColor = CustomColor.gray80
        $0.isSkeletonable = true
    }
    
    let writeButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 31
        $0.backgroundColor = CustomColor.red
        $0.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            categoryCollectionView,
            viewOptionButton, alignButton,
            productCollectionView, writeButton
        )
//        let refreshControl = UIRefreshControl()
//        refreshControl.tintColor = .black
//        productCollectionView.refreshControl = refreshControl
    }
    
    override func setLayout() {
        
        categoryCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(56.0)
        }
        
        viewOptionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18.0)
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8.0)
            make.height.equalTo(22)
        }
    
        alignButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18.0)
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8.0)
            make.height.equalTo(22)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(alignButton.snp.bottom).offset(8.0)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(62)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(7)
            make.trailing.equalToSuperview().inset(11)
        }
    }
}

// MARK: - 컴포지셔널 레이아웃
extension MarketView {
    
    // TODO: View 수직 스크롤 끄기
    func setCategoryLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(70),
                    heightDimension: .estimated(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(3.0),
                    heightDimension: .estimated(64.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 15
                section.contentInsets.leading = 16
                section.contentInsets.bottom = 15
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
                section.contentInsets.top = 10
                section.contentInsets.leading = 8
                section.contentInsets.trailing = 8
                section.contentInsets.bottom = 72
   
                return section
        }
    }
}
