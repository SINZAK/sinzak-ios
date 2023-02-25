//
//  AddPhotosVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit

final class AddPhotosVC: SZVC {
    // MARK: - Properties
    private let mainView = AddPhotosView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Actions
    @objc func nextButtonTapped(_ sender: UIButton) {
        let vc = ArtworkInfoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.register(AddPhotoCVC.self, forCellWithReuseIdentifier: String(describing: AddPhotoCVC.self))
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.collectionViewLayout = setLayout()
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.addPhotos
    }
}
extension AddPhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AddPhotoCVC.self), for: indexPath) as? AddPhotoCVC else { return UICollectionViewCell() }
        return cell
    }
}
// 컴포지셔널 레이아웃
extension AddPhotosVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(105),
                heightDimension: .estimated(105))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(680),
                heightDimension: .estimated(105))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(12)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 16
            section.interGroupSpacing = 0
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}
