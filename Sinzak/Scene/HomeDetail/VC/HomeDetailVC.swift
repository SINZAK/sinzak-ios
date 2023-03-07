//
//  HomeDetailVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class HomeDetailVC: SZVC {
    // MARK: - Properties
    let mainView = HomeDetailView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "맞춤 장르"
    }
    override func configure() {
        mainView.detailCollectionView.delegate = self
        mainView.detailCollectionView.dataSource = self
        mainView.detailCollectionView.collectionViewLayout = setLayout()
        mainView.detailCollectionView.register(ArtFullWidthCVC.self, forCellWithReuseIdentifier: String(describing: ArtFullWidthCVC.self))
    }
}
extension HomeDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArtFullWidthCVC.self), for: indexPath) as? ArtFullWidthCVC else { return UICollectionViewCell() }
        return cell
    }
}
// 컴포지셔널 레이아웃
extension HomeDetailVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets.leading = 16
            item.contentInsets.trailing = 16
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(240))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.top = 32
            section.interGroupSpacing = 20
            return section
        }
    }
}
