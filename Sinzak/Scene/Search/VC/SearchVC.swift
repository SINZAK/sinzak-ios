//
//  SearchVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/14.
//

import UIKit

final class SearchVC: SZVC {
    // MARK: - Properties
    private let historyView = SearchHistoryView()
    private let resultView = SearchResultView()
    var query = String() {
        didSet {
            // rx로 바꾸기
            view = resultView
            resultView.collectionView.reloadData()
        }
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = historyView
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
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        let searchBar = UISearchBar()
        searchBar.placeholder = I18NStrings.workRequestSearchPlaceholder
        self.navigationItem.titleView = searchBar
    }
}
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // 아이템 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if query.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchHistoryCVC.self), for: indexPath) as? SearchHistoryCVC else { return UICollectionViewCell() }
            cell.queryLabel.text = "쿼리 xx"
            return cell
        } else {
            return UICollectionViewCell()
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
}
