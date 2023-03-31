//
//  MarketVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MarketVC: SZVC {
    // MARK: - Properties
    let viewModel: MarketVM!
    let mainView = MarketView()
    
    enum SectionKind: Int {
        case category = 0
        case art
    }
    
    let searchBarButton = UIBarButtonItem(
        image: UIImage(named: "search"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    // MARK: - Init
    init(viewModel: MarketVM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configure()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "마켓"
        navigationItem.rightBarButtonItem = searchBarButton
    }
    override func configure() {
        mainView.collectionView.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: String(describing: ArtCVC.self)
        )
        mainView.collectionView.register(
            CategoryTagCVC.self,
            forCellWithReuseIdentifier: String(describing: CategoryTagCVC.self)
        )
        mainView.collectionView.register(
            MarketHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: MarketHeader.self)
        )
        mainView.collectionView.collectionViewLayout = setLayout()
    }
}

// MARK: - Bind
extension MarketVC {
    func bind() {
        bindInput()
        bindOutput()
        
        let dataSource = dataSource()
        Observable.just(viewModel.sections)
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindInput() {
        mainView.writeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.writeButtonTapped()
            })
            .disposed(by: disposeBag)
        
         searchBarButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.searchButtonTapped()
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        viewModel.pushWriteCategoryVC
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushSerachVC
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// 컴포지셔널 레이아웃
extension MarketVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
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
                section.contentInsets.bottom = 15
                section.interGroupSpacing = 0
                section.orthogonalScrollingBehavior = .continuous
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
                section.contentInsets.top = 10
                section.contentInsets.leading = 8
                section.contentInsets.trailing = 8
                section.contentInsets.bottom = 72
                // 헤더 설정
                let headerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(24))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                headerItem.contentInsets.leading = 16
                headerItem.contentInsets.trailing = 16
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
        }
    }
}

// MARK: - DataSouce

private extension MarketVC {
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<MarketSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MarketSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .categorySectionItem(category):
                    guard let cell: CategoryTagCVC = collectionView.dequeueReusableCell(
                        withReuseIdentifier: String(describing: CategoryTagCVC.self),
                        for: indexPath
                    ) as? CategoryTagCVC else { return UICollectionViewCell() }
                    cell.categoryLabel.text = category.text
                    if indexPath.item == 0 {
                        cell.setColor(kind: .selected)
                    }
                    return cell
                    
                case let .artSectionItem(marketProduct):
                    guard let cell: ArtCVC = collectionView.dequeueReusableCell(
                        withReuseIdentifier: String(describing: ArtCVC.self),
                        for: indexPath
                    ) as? ArtCVC else { return UICollectionViewCell() }
                    cell.setData(marketProduct)
                    return cell
                }
            },
            configureSupplementaryView: { _, collectionView, _, indexPath in
                if indexPath.section != 0 {
                    guard let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: String(describing: MarketHeader.self),
                        for: indexPath
                    ) as? MarketHeader else { return UICollectionReusableView() }
                    return header
                } else {
                    return UICollectionReusableView()
                }
            })
    }
}
