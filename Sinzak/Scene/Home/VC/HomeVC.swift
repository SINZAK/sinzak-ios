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
import SkeletonView

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
        viewModel.fetchData()
//        viewModel.viewDidLoad()
        
//        mainView.homeCollectionView.isHidden = true
//        mainView.skeletonView.isHidden = false
//        view.showAnimatedSkeleton()

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
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        mainView.homeCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.fetchData()
            })
            .disposed(by: disposeBag)
        
        // TODO: 아이디 전달해서 상세 조회 하게 수정해야함
        mainView.homeCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                
                if indexPath.section == 0 {
                    Log.debug("배너 탭!")
                    return
                }
                
                guard let cell = owner.mainView.homeCollectionView.cellForItem(at: indexPath) as? ArtCVC else { return }
                guard let products = cell.products else { return }
                owner.viewModel.tapProductsCell(products: products)
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindOutput() {
        
        viewModel.showSkeleton
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, showSkeleton in
                if showSkeleton {
                    owner.view.showAnimatedSkeleton()
                    owner.mainView.skeletonView.isHidden = false
                    owner.view.layoutIfNeeded()
                } else {
                    owner.view.hideSkeleton()
                    owner.mainView.skeletonView.isHidden = true
                    owner.mainView.homeCollectionView.refreshControl?.endRefreshing()
                    owner.view.layoutIfNeeded()
                }})
            .disposed(by: disposeBag)
        
        viewModel.homeSectionModel
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.homeCollectionView.rx.items(dataSource: getHomeDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.pushProductsDetailView
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, vc in
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc func didNotificitionButtonTapped(_ sender: UIBarButtonItem) {
//        let vc = NotificationVC()
//        navigationController?.pushViewController(vc, animated: true)
        
        self.viewModel.fetchData()
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
        mainView.skeletonView.homeProductSekeletoneCollectionView.dataSource = self
        view.isSkeletonable = true
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
                section.contentInsets.top = 40
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

extension HomeVC: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> SkeletonView.ReusableCellIdentifier {
        
        return ArtCVC.identifier
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ArtCVC.identifier,
            for: indexPath
        ) as? ArtCVC else { return UICollectionViewCell() }
        cell.setSkeleton()
        return cell
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        skeletonCellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell? {
        guard let cell = skeletonView.dequeueReusableCell(
            withReuseIdentifier: ArtCVC.identifier,
            for: indexPath
        ) as? ArtCVC else { return UICollectionViewCell() }
        cell.setSkeleton()
        return cell
    }
}
