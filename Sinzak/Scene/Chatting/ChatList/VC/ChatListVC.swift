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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Helper
    override func setNavigationBar() {
        navigationItem.title = "채팅"
    }
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ChatListCVC.self, forCellWithReuseIdentifier: String(describing: ChatListCVC.self))
        mainView.collectionView.collectionViewLayout = createLayout()
    }
}
extension ChatListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // 아이템 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ChatListCVC.self), for: indexPath) as? ChatListCVC else { return UICollectionViewCell() }
        cell.verifiedBadge.isHidden = indexPath.item % 3 < 1 ? true : false
        cell.chatCountBackground.isHidden = indexPath.item % 3 > 0 ? true : false
        return cell
    }
    // 셀 클릭했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatVC()
        // vc에 대화정보 전달
        // 소켓통신 열기
        navigationController?.pushViewController(vc, animated: true)
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
