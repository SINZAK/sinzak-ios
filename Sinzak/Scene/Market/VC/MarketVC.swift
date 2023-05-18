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
import SkeletonView

enum MarketMode {
    case watch
    case search
}

final class MarketVC: SZVC {
    // MARK: - Properties
    private let viewModel: MarketVM!
    private let mainView = MarketView()
    
    private let disposeBag = DisposeBag()
    
    private var marketMode: MarketMode
    
    var currentTappedCell: BehaviorRelay<Int> = .init(value: -1)
    
    var isViewDidLoad: Bool = true
    var isCurrentMarketView: Bool = false
    
    let searchBarButton = UIBarButtonItem(
        image: UIImage(named: "search"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "작품 통합 검색"
        searchBar.tintColor = CustomColor.red
        
        return searchBar
    }()

    // MARK: - Init
    init(viewModel: MarketVM, mode: MarketMode) {
        self.viewModel = viewModel
        self.marketMode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if marketMode == .search {
            self.navigationItem.titleView = searchBar
            self.navigationItem.rightBarButtonItem = nil
            viewModel.refresh()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        isCurrentMarketView = true
        if viewModel.needRefresh.value {
            viewModel.refresh()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isCurrentMarketView = false
        viewModel.needRefresh.accept(false)
    }

    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "마켓"
        navigationItem.rightBarButtonItem = searchBarButton
    }
    override func configure() {
        bind()
        mainView.marketSkeletonView.productCollectionView.dataSource = self
        view.isSkeletonable = true
    }
}

// MARK: - Bind
private extension MarketVC {
    func bind() {
        bindInput()
        bindOutput()
        
        mainView.productCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.productsCellLikeUpdate)
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(with: self, onNext: { owner, notification in
                guard let info = notification.userInfo else { return }
                let id = info["id"] as? Int ?? 0
                let isLike = info["isSelected"] as? Bool ?? false
                let likeCount = info["likeCount"] as? Int ?? 0

                let section = owner.viewModel.productSections.value[0]
                
                var newProducts: [Products] = []
                for product in section.items {
                    var product = product
                    if product.id == id {
                        product.like = isLike
                        product.likesCnt = likeCount
                    }
                    newProducts.append(product)
                }
                
                let newSections = [MarketProductDataSection(items: newProducts)]
                owner.viewModel.productSections.accept(newSections)
            })
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
        
        mainView.viewOptionButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let current = self?.viewModel.isSaling.value ?? false
                self?.viewModel.isSaling.accept(!current)
                self?.viewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        mainView.alignButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.alignButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.productCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let offset = 8.0 + (owner
                    .mainView
                    .productCollectionView
                    .refreshControl?
                    .frame
                    .height ?? 0)
                owner.viewModel.refresh()
                owner
                    .mainView
                    .marketSkeletonView
                    .productCollectionView.snp.updateConstraints {
                        $0.top.equalTo(owner.mainView.alignButton.snp.bottom).offset(offset)
                    }
            })
            .disposed(by: disposeBag)
        
        mainView.categoryCollectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                
                // 다른 카테고리 선택시 전체 deselect
                if indexPath != [0, 0] {
                    owner.mainView.categoryCollectionView.deselectItem(at: [0, 0], animated: false)
                }
                    
                // 전체 선택시 나머지 deselect
                if indexPath == [0, 0] {
                    Array(1..<ProductsCategory.allCases.count)
                        .filter { owner.getCategoryCell(at: [0, $0]).isSelected }
                        .forEach { owner
                            .mainView
                            .categoryCollectionView
                            .deselectItem(at: [0, $0], animated: false)
                        }
                }
                
                guard let selectedIndexPathes = owner
                    .mainView
                    .categoryCollectionView
                    .indexPathsForSelectedItems else { return }
                                
                if selectedIndexPathes.count == 4 {
                    owner
                        .mainView
                        .categoryCollectionView
                        .deselectItem(at: indexPath, animated: false)
                } else {
                    owner.mainView.categoryCollectionView.scrollToItem(
                        at: indexPath,
                        at: .centeredHorizontally,
                        animated: true
                    )
                    let selectedCategory: [ProductsCategory] = indexPath == [0, 0] ?
                    [] :
                    selectedIndexPathes.map {
                        ProductsCategory.allCases[$0.item]
                    }
                    Log.debug(selectedCategory)
                    owner.viewModel.selectedCategory.accept(selectedCategory)
                    owner.viewModel.refresh()
                }
            })
            .disposed(by: disposeBag)
    
        mainView.categoryCollectionView.rx.itemDeselected
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                
                guard let selectedIndexPathes = owner
                    .mainView
                    .categoryCollectionView
                    .indexPathsForSelectedItems else { return }
                
                if selectedIndexPathes.count == 0 {
                    
                    owner
                        .mainView
                        .categoryCollectionView
                        .selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
                    owner.viewModel.selectedCategory.accept([])
                    owner.viewModel.refresh()
                } else {
                    owner.mainView.categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    let selectedCategory: [ProductsCategory] = selectedIndexPathes.map {
                        ProductsCategory.allCases[$0.item]
                    }
                    Log.debug(selectedCategory)
                    owner.viewModel.selectedCategory.accept(selectedCategory)
                    owner.viewModel.refresh()
                }
                
            })
            .disposed(by: disposeBag)
        
        mainView.productCollectionView.rx.modelSelected(Products.self)
            .bind(with: self, onNext: { owner, products in
                let vm = DefaultProductsDetailVM(type: .purchase, refresh: owner.viewModel.refresh)
                let vc = ProductsDetailVC(id: products.id, type: .purchase, viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.productCollectionView.rx.willBeginDragging
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.searchBar.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let text = owner.searchBar.text ?? ""
                if text.count < 2 {
                    owner.showSinglePopUpAlert(message: "2글자 이상 입력해 주세요.")
                    return
                }
                owner.viewModel.searchText.accept(text)
                owner.viewModel.refresh()
                owner.searchBar.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
    
        // MARK: - 화면이동
        viewModel.presentWriteCategoryVC
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vc in
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushSerachVC
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, vc in
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.presentSelectAlignVC
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vc in
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
            
        // MARK: - Collection View Section
        viewModel.categorySections
            .bind(to: mainView.categoryCollectionView.rx.items(dataSource: getCategoryDataSource()))
            .disposed(by: disposeBag)
        
        let productSections = viewModel.productSections
            .asDriver()
        
        productSections
            .drive(mainView.productCollectionView.rx.items(dataSource: getProductDataSource()))
            .disposed(by: disposeBag)
        
        productSections
            .map { !$0[0].items.isEmpty }
            .distinctUntilChanged()
            .drive(mainView.nothingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // MARK: - 검색 옵션
        viewModel.isSaling
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] in
                if $0 {
                    self?.mainView.viewOptionButton.setImage(UIImage(named: "radiobtn-checked"), for: .normal)
                } else {
                    self?.mainView.viewOptionButton.setImage(UIImage(named: "radiobtn-unchecked"), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedAlign
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .recommend)
            .drive(onNext: { [weak self] alignOption in
                guard let self = self else { return }
                self.mainView.alignButton.setTitle(alignOption.text, for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.showSkeleton
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(
                with: self,
                onNext: { owner, showSkeleton in
                    if showSkeleton {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        owner.mainView.marketSkeletonView.isHidden = false
                        owner.view.showAnimatedSkeleton()
                        owner.mainView.productCollectionView.isHidden = true
                        owner.mainView.productCollectionView.scroll(
                            to: .top,
                            animated: false
                        )
                    } else {
                        owner.mainView.productCollectionView.isHidden = false
                        owner.view.hideSkeleton()
                        owner.mainView.marketSkeletonView.isHidden = true
                        
                        if owner.mainView.productCollectionView.refreshControl?.isRefreshing ?? false {
                            owner
                                .mainView
                                .marketSkeletonView
                                .productCollectionView.snp.updateConstraints {
                                    $0.top.equalTo(owner.mainView.alignButton.snp.bottom)
                                }
                            owner.mainView.productCollectionView.refreshControl?.endRefreshing()
                        }
                    }
                })
            .disposed(by: disposeBag)
        
        viewModel.selectedCategory
            .withUnretained(self)
            .subscribe(onNext: { owner, categories in
                
                if owner.isCurrentMarketView { return }
                
                guard let indexPathsForSelectedItems = owner
                    .mainView
                    .categoryCollectionView
                    .indexPathsForSelectedItems else { return }
                
                indexPathsForSelectedItems
                    .forEach {
                        owner
                            .mainView
                            .categoryCollectionView
                            .deselectItem(at: $0, animated: false)
                    }
                
                if categories.isEmpty {
                    owner.mainView.categoryCollectionView.selectItem(
                        at: [0, 0],
                        animated: true,
                        scrollPosition: .centeredHorizontally
                    )
                    return
                }
                
                if owner.marketMode == .watch {
                    let idx: Int = ProductsCategory.allCases.firstIndex(of: categories[0]) ?? 0
                    owner.mainView.categoryCollectionView.selectItem(
                        at: [0, idx],
                        animated: true,
                        scrollPosition: .centeredHorizontally
                    )
                } else {
                    categories.forEach {
                        let idx: Int = ProductsCategory.allCases.firstIndex(of: $0) ?? 0
                        owner.mainView.categoryCollectionView.selectItem(
                            at: [0, idx],
                            animated: true,
                            scrollPosition: .centeredHorizontally
                        )
                    }
                }
                
            })
            .disposed(by: disposeBag)
    }
}

extension MarketVC: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == viewModel.productSections.value[0].items.count - 2 {
            Log.debug("fetct")
            viewModel.fetchNextPage()
        }
    }
    
}

// MARK: - DataSouce

private extension MarketVC {
    func getCategoryDataSource() -> RxCollectionViewSectionedReloadDataSource<CategoryDataSection> {
        return RxCollectionViewSectionedReloadDataSource<CategoryDataSection>(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                guard let cell: CategoryTagCVC = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryTagCVC.identifier,
                    for: indexPath
                ) as? CategoryTagCVC else { return UICollectionViewCell() }
                
                if item.category.needSelect && self.isViewDidLoad {
                    self.mainView.categoryCollectionView.selectItem(
                        at: indexPath,
                        animated: false,
                        scrollPosition: .centeredHorizontally
                    )
                    self.isViewDidLoad = false
                }
                cell.updateProductsCell(category: item.category.type)
                return cell
            })
    }
    
    func getProductDataSource() -> RxCollectionViewSectionedReloadDataSource<MarketProductDataSection> {
        return RxCollectionViewSectionedReloadDataSource<MarketProductDataSection>(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                guard let cell: ArtCVC = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ArtCVC.identifier,
                    for: indexPath
                ) as? ArtCVC else { return UICollectionViewCell() }
                cell.setData(
                    item,
                    .products,
                    self.needLogIn,
                    self.currentTappedCell
                )
                return cell
            })
    }
}

// MARK: - Private Method

private extension MarketVC {
    func getCategoryCell(at indexPath: IndexPath) -> CategoryTagCVC {
        guard let cell = mainView
            .categoryCollectionView
            .cellForItem(at: indexPath) as? CategoryTagCVC else { return CategoryTagCVC() }
        return cell
    }
}

// MARK: - Configure Skeleton View

extension MarketVC: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> SkeletonView.ReusableCellIdentifier {
        return ArtCVC.identifier
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 6
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell: ArtCVC = collectionView.dequeueReusableCell(
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
