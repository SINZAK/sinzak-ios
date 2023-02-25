//
//  WriteCategoryVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit

enum WriteCategorySection: Int, CaseIterable {
    case genre = 0
    case category
}

final class WriteCategoryVC: SZVC {
    // MARK: - Properties
    private let mainView = WriteCategoryView()
    // MARK: - Helpers
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
    // MARK: - Actions
    @objc private func nextButtonTapped(_ sender: UIButton) {
        let vc = AddPhotosVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(WriteCategoryHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: String(describing: WriteCategoryHeader.self))
        mainView.collectionView.register(WriteCategoryCVC.self, forCellWithReuseIdentifier: String(describing: WriteCategoryCVC.self))
        mainView.collectionView.register(WriteCategoryTagCVC.self, forCellWithReuseIdentifier: String(describing: WriteCategoryTagCVC.self))
        mainView.collectionView.collectionViewLayout = setLayout()
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.categorySelection
    }
}
extension WriteCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return WriteCategorySection.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == WriteCategorySection.genre.rawValue {
            return WriteCategory.allCases.count
        } else if section == WriteCategorySection.category.rawValue {
            // 활성화된 버튼따라 숫자가 다름
            return 5
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == WriteCategorySection.genre.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WriteCategoryCVC.self), for: indexPath) as? WriteCategoryCVC else { return UICollectionViewCell() }
            cell.updateCell(kind: WriteCategory.allCases[indexPath.item])
            return cell
        } else if indexPath.section == WriteCategorySection.category.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WriteCategoryTagCVC.self), for: indexPath) as? WriteCategoryTagCVC else { return UICollectionViewCell() }
            cell.updateCell(kind: WorksCategory.allCases[indexPath.item])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    // 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if [ WriteCategorySection.genre.rawValue, WriteCategorySection.category.rawValue].contains(indexPath.section) {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: WriteCategoryHeader.self), for: indexPath) as? WriteCategoryHeader else { return UICollectionReusableView()}
            header.update(kind: WriteCategoryHeaderKind.allCases[indexPath.section])
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
// 컴포지셔널 레이아웃
extension WriteCategoryVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            // 카테고리 경우
            if sectionNumber == WriteCategorySection.genre.rawValue {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.3),
                    heightDimension: .fractionalWidth(0.3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 20
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                section.contentInsets.bottom = 40
                section.interGroupSpacing = 0
                // 헤더 설정
                let headerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                return section
            } else { // 카테고리일 경우
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(70),
                    heightDimension: .estimated(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(6)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 15
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                section.contentInsets.bottom = 15
                section.interGroupSpacing = 10
                // 헤더 설정
                let headerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
        }
    }
}
