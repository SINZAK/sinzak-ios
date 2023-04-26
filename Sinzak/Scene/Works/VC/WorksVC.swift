//
//  WorksVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/29.
//

import UIKit
import RxSwift
import RxCocoa

final class WorksVC: SZVC {
    // MARK: - Properties
    let mainView = WorksView()
    enum SectionKind: Int {
        case category = 0
        case art
    }
    var worksitem: [Products] = []
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Actions
    /// 검색화면으로 이동
    @objc func searchButtonTapped(_ sender: UIBarButtonItem) {
        let vc = SearchVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func writeButtonTapped(_ sender: UIButton) {
        let vc = WriteCategoryVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "외주"
        let search = UIBarButtonItem(
            image: UIImage(named: "search"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = search
    }
    override func configure() {
        mainView.writeButton.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ArtCVC.self, forCellWithReuseIdentifier: String(describing: ArtCVC.self))
        mainView.collectionView.register(CategoryTagCVC.self, forCellWithReuseIdentifier: String(describing: CategoryTagCVC.self))
        mainView.collectionView.register(WorksHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: String(describing: WorksHeader.self))
        mainView.collectionView.collectionViewLayout = setLayout()
    }
}
extension WorksVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == SectionKind.category.rawValue ? WorksCategory.allCases.count : worksitem.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == SectionKind.category.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryTagCVC.self), for: indexPath)  as? CategoryTagCVC else { return UICollectionViewCell() }
            cell.categoryLabel.text = WorksCategory.allCases[indexPath.item].text
            if indexPath.item == 0 {
                cell.setColor(kind: .selected)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArtCVC.self), for: indexPath) as? ArtCVC else { return UICollectionViewCell() }
            let item = worksitem[indexPath.item]
            cell.setData(item, .work ,PublishRelay<Bool>())
            return cell
        }
    }
    // 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == SectionKind.category.rawValue {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(describing: WorksHeader.self),
                for: indexPath
            ) as? WorksHeader else { return UICollectionReusableView() }
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
// 컴포지셔널 레이아웃
extension WorksVC {
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
                    widthDimension: .fractionalWidth(3.0),
                    heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 15
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                section.contentInsets.bottom = 15
                section.interGroupSpacing = 0
                section.orthogonalScrollingBehavior = .continuous
                // 헤더 설정
                let headerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                return section
            } else { // 카테고리가 아닐 경우
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1.0)
                )
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(276)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets.leading = 8
                item.contentInsets.trailing = 8
                item.contentInsets.bottom = 16
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 8
                section.contentInsets.trailing = 8
                section.contentInsets.bottom = 72
                return section
            }
        }
    }
}
