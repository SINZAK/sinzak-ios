//
//  SearchVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/14.
//

import UIKit

enum SectionKind: Int {
    case category = 0 // 검색결과에서 카테고리
}

final class SearchVC: SZVC {
    // MARK: - Properties
    private let historyView = SearchHistoryView()
    private let resultView = SearchResultView()
    var query = "Hello" {
        didSet {
            // rx로 바꾸기
            view = resultView
            resultView.collectionView.reloadData()
        }
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = resultView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Actions
    /// 쿼리를 모두 삭제
    @objc private func deleteAllQuery(_ sender: UIButton) {
        self.showAlert(title: "모두 삭제하시겠습니까?", okText: "네, 삭제합니다.", cancelNeeded: true) { _ in
            // 쿼리 삭제 구현 코드 필요
        }
    }
    // MARK: - Helpers
    override func configure() {
        tabBarController?.tabBar.isHidden = true
        /** 검색어 히스토리 콜렉션뷰 */
        historyView.removeAllButton.addTarget(self, action: #selector(deleteAllQuery), for: .touchUpInside)
        historyView.collectionView.delegate = self
        historyView.collectionView.dataSource = self
        historyView.collectionView.collectionViewLayout = createListLayout()
        historyView.collectionView.register(SearchHistoryCVC.self, forCellWithReuseIdentifier: String(describing: SearchHistoryCVC.self))
        /** 검색 결과 콜렉션뷰 */
        resultView.collectionView.delegate = self
        resultView.collectionView.dataSource = self
        resultView.collectionView.register(SearchResultHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: String(describing: SearchResultHeader.self))
        resultView.collectionView.register(ArtCVC.self, forCellWithReuseIdentifier: String(describing: ArtCVC.self))
        resultView.collectionView.register(CategoryTagCVC.self, forCellWithReuseIdentifier: String(describing: CategoryTagCVC.self))
        resultView.collectionView.collectionViewLayout = setResultLayout()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        let searchBar = UISearchBar()
        searchBar.placeholder = I18NStrings.workRequestSearchPlaceholder
        self.navigationItem.titleView = searchBar
    }
}
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // 섹션
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if query.isEmpty {
            return 1
        }  else {
            return 2
        }
    }
    // 아이템 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if query.isEmpty {
            return 5 // 쿼리 갯수
        } else {
            return section == SectionKind.category.rawValue ? WorksCategory.allCases.count : 9
        }
    }
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if query.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchHistoryCVC.self), for: indexPath) as? SearchHistoryCVC else { return UICollectionViewCell() }
            cell.queryLabel.text = "쿼리 xx"
            return cell
        } else {
            if indexPath.section == SectionKind.category.rawValue {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryTagCVC.self), for: indexPath)  as? CategoryTagCVC else { return UICollectionViewCell() }
                cell.categoryLabel.text = WorksCategory.allCases[indexPath.item].text
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
    // 셀 클릭했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if query.isEmpty {
            // 클릭시 쿼리로 검색하기
            print(indexPath.item)
        } else {
            // 이미지 상세로 넘어가기
        }
    }
    // 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if !query.isEmpty {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: SearchResultHeader.self), for: indexPath) as? SearchResultHeader else { return UICollectionReusableView() }
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
// 컴포지셔널 레이아웃
extension SearchVC {
    /// 컴포지셔널 레이아웃 세팅
    /// - 검색어히스토리는 테이블뷰와 비슷한 형태이므로 list configuration 적용
    private func createListLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.separatorConfiguration.color = .clear
        // 트레일링 액션으로 삭제 적용
        config.trailingSwipeActionsConfigurationProvider = { [ unowned self ] indexPath in
            let delete = UIContextualAction(style: .normal, title: nil) { _, _, _ in
                // 삭제하기
                self.showAlert(title: "삭제하시겠습니까?", okText: "네, 삭제합니다.", cancelNeeded: true) { _ in
                    // 쿼리 삭제 구현 코드 필요
                }
            }
            delete.image = UIImage(systemName: "trash.fill")
            delete.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [delete])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    /// - 검색결과 콜렉션 뷰 컴포지셔널 레이아웃
    func setResultLayout() -> UICollectionViewCompositionalLayout {
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
                section.contentInsets.bottom = 20
                return section
            }
        }
    }
}
