//
//  HomeVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/10.
//

import UIKit
import Kingfisher
import Moya
import RxMoya
import RxSwift
import RxCocoa
import RxDataSources

enum HomeType: Int {
    case banner = 0
    case arts
}

final class HomeVC: SZVC {
    // MARK: - Properties
    let mainView = HomeView()
    var viewModel: HomeVM!
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Init
    init(viewModel: HomeVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
    }
    
    func bindOutput() {
        viewModel.homeSectionModel
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.homeCollectionView.rx.items(dataSource: getHomeDataSource()))
            .disposed(by: disposeBag)
    }
    
    @objc func didNotificitionButtonTapped(_ sender: UIBarButtonItem) {
        let vc = NotificationVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func setNavigationBar() {
        let logotype = UIBarButtonItem(
            image: UIImage(named: "logotype-right"),
            style: .plain,
            target: self,
            action: nil
        )
        let notification = UIBarButtonItem(
            image: UIImage(named: "notification")?.withTintColor(.label, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didNotificitionButtonTapped)
        )
        navigationItem.leftBarButtonItem = logotype
        navigationItem.rightBarButtonItem = notification
    }
    override func configure() {
        mainView.homeCollectionView.collectionViewLayout = setLayout()
        mainView.homeCollectionView.register(
            BannerCVC.self,
            forCellWithReuseIdentifier: BannerCVC.identifier
        )
        mainView.homeCollectionView.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier)
        mainView.homeCollectionView.register(
            SeeMoreCVC.self,
            forCellWithReuseIdentifier: SeeMoreCVC.identifier
        )
        mainView.homeCollectionView.register(
            HomeHeader.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: HomeHeader.identifier
        )
    }
}

extension HomeVC {
    
    func getHomeDataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSection> {
        return RxCollectionViewSectionedReloadDataSource<HomeSection>(
            configureCell: { dataSource, collectionView, indexPath, _ in
                switch dataSource[indexPath] {
                case .bannerSectionItem(banner: let banner):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BannerCVC.identifier,
                        for: indexPath
                    ) as? BannerCVC else { return UICollectionViewCell() }
                    cell.setData(banner: banner)
                    return cell
                    
                case .productSectionItem(product: let product):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ArtCVC.identifier,
                        for: indexPath
                    ) as? ArtCVC else { return UICollectionViewCell() }
                    cell.setData(product)
                    return cell
                }
            },
            configureSupplementaryView: { dataSoure, collectionView, kind, indexPath in
                
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HomeHeader.identifier,
                    for: indexPath
                ) as? HomeHeader else { return UICollectionReusableView() }
                
                header.titleLabel.text = dataSoure.sectionModels[indexPath.section].title ?? ""
                
                return header
            })
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
