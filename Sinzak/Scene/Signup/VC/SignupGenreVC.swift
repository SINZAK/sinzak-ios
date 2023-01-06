//
//  SignupGenreVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

final class SignupGenreVC: SZVC {
    // MARK: - Properties
    let mainView = SignupGenreView()
    let genreList = Genre.list
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.collectionViewLayout = setLayout()
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(InterestedGenreCVC.self, forCellWithReuseIdentifier: String(describing: InterestedGenreCVC.self))
        mainView.collectionView.register(InterestedGenreHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: String(describing: InterestedGenreHeader.self))
    }
}

extension SignupGenreVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return genreList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreList[section].category.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InterestedGenreCVC.self), for: indexPath) as? InterestedGenreCVC else { return UICollectionViewCell()}
        cell.textLabel.text = genreList[indexPath.section].category[indexPath.item]
        return cell
    }
    // 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: InterestedGenreHeader.self), for: indexPath) as? InterestedGenreHeader else { return UICollectionReusableView() }
        header.titleLabel.text = genreList[indexPath.section].type
        return header
    }
}

extension SignupGenreVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 5, bottom: 5, trailing: 8)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(130)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
         
        section.interGroupSpacing = 8
        
        let headerItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(30))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 19
        layout.configuration = config
        return layout
    }
}
