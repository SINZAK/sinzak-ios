//
//  MarketVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit

final class MarketVC: SZVC {
    // MARK: - Properties
    let mainView = MarketView()
    enum SectionKind: Int {
        case category = 0
        case art
    }
    // MARK: - Init
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configure()
    }
    // MARK: - Actions
    /// 검색화면으로 이동
    @objc func searchButtonTapped(_ sender: UIBarButtonItem) {
        let vc = SZVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "마켓"
        let search = UIBarButtonItem(
            image: UIImage(named: "search"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = search
    }
    override func configure() {
        view.backgroundColor = CustomColor.white
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ArtCVC.self, forCellWithReuseIdentifier: String(describing: ArtCVC.self))
        mainView.collectionView.register(CategoryTagCVC.self, forCellWithReuseIdentifier: String(describing: CategoryTagCVC.self))
        mainView.collectionView.collectionViewLayout = setLayout()
    }
}
extension MarketVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == SectionKind.category.rawValue ? Category.allCases.count : 9
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == SectionKind.category.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryTagCVC.self), for: indexPath)  as? CategoryTagCVC else { return UICollectionViewCell() }
            cell.categoryLabel.text = Category.allCases[indexPath.item].text
            if indexPath.item == 0 {
                cell.setColor(kind: .selected)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArtCVC.self), for: indexPath) as? ArtCVC else { return UICollectionViewCell() }
            return cell
        }
    }
}
// 컴포지셔널 레이아웃
extension MarketVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
        // 카테고리 경우
            if sectionNumber == SectionKind.category.rawValue {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(70),
                    heightDimension: .estimated(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(2.0),
                    heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 15
                section.contentInsets.leading = 16
                section.contentInsets.bottom = 15
                section.interGroupSpacing = 0
                section.orthogonalScrollingBehavior = .continuous
                return section
            } else { // 카테고리가 아닐 경우
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.47),
                    heightDimension: .fractionalHeight(1.0)
                )
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(240)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(16)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                section.contentInsets.bottom = 72
                // section.interGroupSpacing = 16
                // 헤더 설정
                // let headerItemSize = NSCollectionLayoutSize(
                // widthDimension: .fractionalWidth(1.0),
                // heightDimension: .estimated(40))
                // let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
                // section.boundarySupplementaryItems = [headerItem]
                // section.orthogonalScrollingBehavior = .continuous
                 return section
            }
        }
    }
}
