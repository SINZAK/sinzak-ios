//
//  ChatListVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit

final class ChatListVC: SZVC {
    // MARK: - Properties
    let mainView = ChatListView()
    // MARK: - Init
    override func loadView() {
        view = mainView
    }
    // MARK: - Helper
    override func setNavigationBar() {
        navigationItem.title = "채팅"
    }
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
}
extension ChatListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
// 컴포지셔널 레이아웃
extension ChatListVC {
    /// 컴포지셔널 레이아웃 세팅
    /// - 테이블뷰와 비슷한 형태이므로 list configuration 적용
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.separatorConfiguration.color = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
