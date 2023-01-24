//
//  FollowNotiVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit

final class FollowNotiVC: SZVC {
    // MARK: - Properties
    let mainView = NotiView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.collectionViewLayout = createLayout()
        mainView.collectionView.register(NotificationCVC.self, forCellWithReuseIdentifier: String(describing: NotificationCVC.self))
    }
}
extension FollowNotiVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NotificationCVC.self), for: indexPath) as? NotificationCVC else { return UICollectionViewCell() }
        return cell
    }
}
// 컴포지셔널 레이아웃
extension FollowNotiVC {
    /// 컴포지셔널 레이아웃 세팅
    /// - 테이블뷰와 비슷한 형태이므로 list configuration 적용
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.separatorConfiguration.color = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
