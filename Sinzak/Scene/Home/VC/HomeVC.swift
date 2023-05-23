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
    
    var currentTappedCell: BehaviorRelay<Int> = .init(value: -1)

    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
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
    
    // MARK: - Bind
    
    func bind() {
        bindInput()
        bindOutput()
        
        NotificationCenter.default.rx.notification(.productsCellLikeUpdate)
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(with: self, onNext: { owner, notification in
                guard let info = notification.userInfo else { return }
                let id = info["id"] as? Int ?? 0
                let isLike = info["isSelected"] as? Bool ?? false
                let likeCount = info["likeCount"] as? Int ?? 0
                
                let currentSections: [HomeSection] = owner.viewModel.homeSectionModel.value
                var newSections: [HomeSection] = []
                
                for section in currentSections {
                    switch section {
                    case .productSection(let title, let items):
                        var products: [Products] = []
                        for item in items {
                            switch item {
                            case .productSectionItem(let product):
                                var product = product
                                if product.id == id {
                                    product.like = isLike
                                    product.likesCnt = likeCount
                                }
                                products.append(product)
                            default:
                                break
                            }
                        }
                        let items: [HomeSectionItem] = products.map { .productSectionItem(product: $0) }
                        let section = HomeSection.productSection(title: title, items: items)
                        newSections.append(section)
                    default:
                        newSections.append(section)
                    }
                }
                owner.viewModel.homeSectionModel.accept(newSections)
            })
            .disposed(by: disposeBag)
    }
    
    func bindInput() {
        
        mainView.homeCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                
                owner.mainView.skeletonView.snp.remakeConstraints {
                    $0.trailing.leading.equalToSuperview()
                    $0.top.equalTo(owner.view.safeAreaLayoutGuide)
                        .offset(owner.mainView.refreshControl.bounds.height)
                    $0.bottom.equalTo(owner.view.safeAreaLayoutGuide)
                }
                
                owner.viewModel.fetchData()
            })
            .disposed(by: disposeBag)
        
        mainView.homeCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                
                for (i, zip) in owner.viewModel.moreCell.enumerated() where indexPath == [i+1, zip.1 - 1] {
                    
                    guard let cell = owner.mainView.homeCollectionView.cellForItem(at: indexPath) as? SeeMoreCVC else { return }
                    
                    let alignOption = cell.alignOption
                    
                    // 로그인 상태, 팔로우 보여주는 섹션은 액션 없어야함
                    if owner.viewModel.isLogin && alignOption == .popular { return }
                    
                    if !owner.viewModel.isLogin && alignOption == .high {
                        owner.viewModel.selectedCategory.accept([])
                        owner.viewModel.selectedAlign.accept(.recommend)
                        owner.viewModel.isSaling.accept(true)
                        owner.viewModel.needRefresh.accept(true)
                        owner.tabBarController?.selectedIndex = 1
                        
                        return
                    }
                    
                    owner.viewModel.selectedCategory.accept([])
                    owner.viewModel.selectedAlign.accept(zip.0)
                    owner.viewModel.isSaling.accept(false)
                    owner.viewModel.needRefresh.accept(true)
                    owner.tabBarController?.selectedIndex = 1
                    
                    return
                }
                
                let sectionCount = owner.viewModel.homeSectionModel.value.count
                
                switch indexPath.section {
                case 0:
                    if indexPath.section == 0 {
                        Log.debug("배너 탭!")
                    }
                case 1..<sectionCount-1:
                    owner.mainView.homeCollectionView.deselectItem(at: indexPath, animated: false)
                    guard let cell = owner.mainView.homeCollectionView.cellForItem(at: indexPath) as? ArtCVC else { return }
                    guard let products = cell.products else { return }
                    owner.viewModel.tapProductsCell(products: products)
                default:
                    
                    let category: ProductsCategory = ProductsCategory.allCases[indexPath.item + 1]
                    owner.viewModel.selectedCategory.accept([category])
                    owner.viewModel.selectedAlign.accept(.recommend)
                    owner.viewModel.isSaling.accept(false)
                    owner.viewModel.needRefresh.accept(true)
                    owner.tabBarController?.selectedIndex = 1
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
        viewModel.showSkeleton
            .skip(1)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, showSkeleton in
                if showSkeleton {
                    owner.view.showAnimatedSkeleton()
                    owner.mainView.skeletonView.isHidden = false
                    owner.mainView.homeCollectionView.isHidden = true
                    Array(0..<owner.viewModel.homeSectionModel.value.count)
                        .reversed()
                        .forEach {
                            owner
                                .mainView
                                .homeCollectionView
                                .scrollToItem(
                                    at: IndexPath(item: 0, section: $0),
                                    at: .left,
                                    animated: false
                                )
                        }
                    
                } else {
                    owner.view.hideSkeleton()
                    owner.mainView.skeletonView.snp.remakeConstraints {
                        $0.trailing.leading.equalToSuperview()
                        $0.top.equalTo(owner.view.safeAreaLayoutGuide)
                        $0.bottom.equalTo(owner.view.safeAreaLayoutGuide)
                    }
                    owner.mainView.homeCollectionView.isHidden = false
                    owner.mainView.skeletonView.isHidden = true
                    owner.mainView.homeCollectionView.refreshControl?.endRefreshing()
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
        bind()
        mainView.homeCollectionView.collectionViewLayout = setLayout()
        mainView.skeletonView.collectionView1.dataSource = self
        mainView.skeletonView.collectionView2.dataSource = self
        view.isSkeletonable = true
    }
}

extension HomeVC {
    
    func getHomeDataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSection> {
        return RxCollectionViewSectionedReloadDataSource<HomeSection>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, _ in
                guard let self = self else { return UICollectionViewCell() }
                
                switch dataSource[indexPath] {
                case .bannerSectionItem(banner: let banner):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BannerCVC.identifier,
                        for: indexPath
                    ) as? BannerCVC else { return UICollectionViewCell() }
                    cell.setData(banner: banner)
                    return cell
                    
                case .productSectionItem(product: let product):
                    if product.thumbnail == "moreCell" {
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: SeeMoreCVC.identifier,
                            for: indexPath
                        ) as? SeeMoreCVC else { return UICollectionViewCell() }
                        
                        cell.alignOption = self.viewModel.moreCell[indexPath.section-1].0
                        
                        return cell
                        
                    } else {
                        
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ArtCVC.identifier,
                            for: indexPath
                        ) as? ArtCVC else { return UICollectionViewCell() }
                        cell.setData(
                            product,
                            .products,
                            self.needLogIn,
                            self.currentTappedCell
                        )
                        
                        return cell
                    }
                    
                case .categoryItem(category: let category):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HomeCategoryCVC.identifier,
                        for: indexPath
                    ) as? HomeCategoryCVC else { return UICollectionViewCell() }
                    
                    cell.configureCell(with: category.image)
                    return cell
                }
            },
            configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
                guard let self = self else { return UICollectionReusableView() }
                
                switch indexPath.section {
                case 0:
                    guard let footer = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: BannerFooter.identifier,
                        for: indexPath
                    ) as? BannerFooter else { return UICollectionReusableView() }
                    footer.configFooter(
                        self.viewModel.bannerIndex,
                        self.viewModel.bannerTotalIndex
                    )
                    return footer
                default:
                    guard let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: HomeHeader.identifier,
                        for: indexPath
                    ) as? HomeHeader else { return UICollectionReusableView() }
                    
                    header.titleLabel.text = dataSource.sectionModels[indexPath.section].title ?? ""
                    
                    return header
                }
                
            }
    )}
}

// 컴포지셔널 레이아웃
extension HomeVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        lazy var sectionCount = viewModel.homeSectionModel.value.count
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            // 배너일 경우
            switch sectionNumber {
            case 0:
                let height = (UIScreen.main.bounds.width - 32) * (Double(608.0) / Double(1368.0))
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(height))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets.leading = 16
                item.contentInsets.trailing = 16
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(height))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 40
                section.contentInsets.bottom = 24
                section.orthogonalScrollingBehavior = .paging
                
                let footerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(8)
                )
                let footerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerItemSize, elementKind: "footer", alignment: .bottom)
                
                section.boundarySupplementaryItems = [footerItem]
                
                section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
                    guard let self = self else { return }
                    
                    let bannerIndex = Int(max(
                        0,
                        round(contentOffset.x / environment.container.contentSize.width)
                    ))
                    self.viewModel.bannerIndex.accept(bannerIndex)
                }
                return section
                
            case 1..<sectionCount-1:
                let numberOfItems = self?.mainView.homeCollectionView.numberOfItems(inSection: sectionNumber) ?? 1
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(164.0),
                    heightDimension: .estimated(256)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(164.0 * CGFloat(numberOfItems-1) + 40.0 * CGFloat(numberOfItems-2)),
                    heightDimension: .estimated(256)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfItems - 1)
                group.contentInsets.leading = 0
                group.contentInsets.trailing = 0
                group.interItemSpacing = .fixed(40.0)
                
                let seeMoreItemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(24.0),
                    heightDimension: .estimated(248.0)
                )
                let seeMoreItem = NSCollectionLayoutItem(layoutSize: seeMoreItemSize)
                seeMoreItem.contentInsets.leading = 8.0
                
                let nestGroupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(164.0 * CGFloat(numberOfItems-1) + 40.0 * CGFloat(numberOfItems-2) + 24.0),
                    heightDimension: .estimated(256.0)
                )
                let nestGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: nestGroupSize,
                    subitems: [group, seeMoreItem]
                )
                
                let section = NSCollectionLayoutSection(group: nestGroup)
                section.interGroupSpacing = 0
                section.contentInsets.leading = 40.0
                section.contentInsets.trailing = 40.0
                section.contentInsets.bottom = 32
                
                // 헤더 설정
                let headerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
                headerItem.contentInsets.leading = -40.0
                section.boundarySupplementaryItems = [headerItem]
                section.orthogonalScrollingBehavior = .continuous
                return section
                
            default:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(80.0),
                    heightDimension: .absolute(80.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets.trailing = 16.0
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(800),
                    heightDimension: .estimated(80.0)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 40.0
                section.contentInsets.trailing = 40.0
                section.contentInsets.bottom = 40.0
                section.interGroupSpacing = 16.0
                
                let headerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40))
                
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
                
                headerItem.contentInsets.leading = -40.0
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
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1
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
