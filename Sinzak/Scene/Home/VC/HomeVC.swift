//
//  HomeVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/10.
//

import UIKit

enum HomeType: Int {
    case banner = 0
    case arts
}

final class HomeVC: SZVC {
    // MARK: - Properties
    let mainView = HomeView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Helpers
    override func setNavigationBar() {
        let logotype = UIBarButtonItem(image: UIImage(named: "logotype-right"),
                                       style: .plain,
                                       target: self,
                                       action: nil)
        let notification = UIBarButtonItem(image: UIImage(named: "notification"),
                                           style: .plain,
                                           target: self,
                                           action: nil )
        navigationItem.leftBarButtonItem = logotype
        navigationItem.rightBarButtonItem = notification
    }
    override func configure() {
        mainView.homeCollectionView.delegate = self
        mainView.homeCollectionView.dataSource = self
        mainView.homeCollectionView.collectionViewLayout = setLayout()
        mainView.homeCollectionView.register(BannerCVC.self, forCellWithReuseIdentifier: String(describing: BannerCVC.self))
        mainView.homeCollectionView.register(ArtCVC.self, forCellWithReuseIdentifier: String(describing: ArtCVC.self))
        mainView.homeCollectionView.register(SeeMoreCVC.self, forCellWithReuseIdentifier: String(describing: SeeMoreCVC.self))
        mainView.homeCollectionView.register(HomeHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: String(describing: HomeHeader.self))
    }
}
// 콜렉션 뷰 세팅
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3 // 배너섹션 : 섹션갯수
    }
    // 섹션 내 아이템 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == HomeType.banner.rawValue ? 3 : 4 // 배너일 경우, 아닐 경우
    }
    // 콜렉션 뷰 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == HomeType.banner.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerCVC.self), for: indexPath) as? BannerCVC else { return UICollectionViewCell()}
            cell.imageView.image = UIImage(named: "banner1")
            return cell
        } else {
            if indexPath.item < 3 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArtCVC.self), for: indexPath) as? ArtCVC else { return UICollectionViewCell()}
                //cell.configure(data: Art) 로 데이터 세팅
                return cell
            } else if indexPath.item == 3 { // 마지막 셀일 경우
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SeeMoreCVC.self), for: indexPath) as? SeeMoreCVC else { return UICollectionViewCell()  }
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
    }
    // 셀 클릭 시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 그냥 셀일 때
        // 더보기셀(=마지막)일 때
        if indexPath.item == 3 {
            let vc = HomeDetailVC()
            vc.navigationItem.title = "팔로잉" // 섹션헤더 정보
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    // 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section != HomeType.banner.rawValue {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: HomeHeader.self), for: indexPath) as? HomeHeader else { return UICollectionReusableView() }
            header.titleLabel.text = "맞춤 거래"
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
// 컴포지셔널 레이아웃
extension HomeVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
        // 배너일 경우
            if sectionNumber == HomeType.banner.rawValue {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets.leading = 16
                item.contentInsets.trailing = 16
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(160))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 24
                section.contentInsets.bottom = 32
                section.orthogonalScrollingBehavior = .paging
                return section
            } else { // 배너가 아닐 경우
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(165),
                    heightDimension: .estimated(240)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(28)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 40
                section.contentInsets.bottom = 40
                section.interGroupSpacing = 28
                // 헤더 설정
                let headerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                section.orthogonalScrollingBehavior = .continuous
                return section
            }
        }
    }
}
