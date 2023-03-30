//
//  MarketVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit

final class MarketVC: SZVC {
    // MARK: - Properties
    let viewModel: MarketVM!
    let mainView = MarketView()
    enum SectionKind: Int {
        case category = 0
        case art
    }
    var marketProduct: [MarketProduct] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
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
        ProductsManager.shared.viewAllProducts(
            align: .popular,
            category: .painting,
            page: 3,
            size: 3,
            sale: true
        ) { [weak self] result in
            switch result {
            case .success(let data):
                print("#########", data)
                self?.marketProduct = data.content
            case .failure(let error):
                print("ERROR", error)
            }
        }
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
        mainView.collectionView.delegate = self
        mainView.collectionView.register(ArtCVC.self, forCellWithReuseIdentifier: String(describing: ArtCVC.self))
        mainView.collectionView.register(CategoryTagCVC.self, forCellWithReuseIdentifier: String(describing: CategoryTagCVC.self))
        mainView.collectionView.register(MarketHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: String(describing: MarketHeader.self))
        mainView.collectionView.collectionViewLayout = setLayout()
    }
}

// MARK: - Bind
extension MarketVC {
    func bind() {
        bindInput()
        bindOutput()
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

extension MarketVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
//        return section == SectionKind.category.rawValue ? Category.allCases.count : marketProduct.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == SectionKind.category.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryTagCVC.self), for: indexPath)  as? CategoryTagCVC else { return UICollectionViewCell() }
            cell.categoryLabel.text = Category.allCases[indexPath.item].text
            if indexPath.item == 0 {
                cell.setColor(kind: .selected)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArtCVC.self), for: indexPath) as? ArtCVC else { return UICollectionViewCell() }
            let item = marketProduct[indexPath.item]
            cell.setData(item)
            return cell
        }
    }
    // 헤더
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if indexPath.section != SectionKind.category.rawValue {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: MarketHeader.self), for: indexPath) as? MarketHeader else { return UICollectionReusableView() }
            return header
        } else {
            return UICollectionReusableView()
        }
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
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
                headerItem.contentInsets.leading = 16
                headerItem.contentInsets.trailing = 16
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
        }
    }
}
