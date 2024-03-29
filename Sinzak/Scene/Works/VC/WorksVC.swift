//
//  WorksVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SkeletonView

enum WorksMode {
    case watch
    case search
}

final class WorksVC: SZVC {
    // MARK: - Properties
    private let viewModel: WorksVM!
    private let mainView = WorksView()
    
    private let disposeBag = DisposeBag()
    
    private var worksMode: WorksMode

    var currentTappedCell: BehaviorRelay<Int> = .init(value: -1)
    
    var worksCollectionViewBeginDragging: PublishRelay<Bool>?

    var isViewDidLoad: Bool = true
    
    var needRefresh: Bool = true

    // MARK: - Init
    init(viewModel: WorksVM, mode: WorksMode) {
        self.viewModel = viewModel
        self.worksMode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(
        viewModel: WorksVM,
        mode: WorksMode,
        worksCollectionViewBeginDragging: PublishRelay<Bool>
    ) {
        self.init(viewModel: viewModel, mode: mode)
        self.worksCollectionViewBeginDragging = worksCollectionViewBeginDragging
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
                
        viewModel.updateAlign()
        
        if needRefresh == true {
            viewModel.refresh()
            needRefresh = false
        }
    }
    
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
    }
    override func configure() {
        bind()
        mainView.marketSkeletonView.productCollectionView.dataSource = self
        view.isSkeletonable = true
    }
}

// MARK: - Bind
private extension WorksVC {
    func bind() {
        bindInput()
        bindOutput()
        
        mainView.worksCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.worksCellLikeUpdate)
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(with: self, onNext: { owner, notification in
                guard let info = notification.userInfo else { return }
                let id = info["id"] as? Int ?? 0
                let isLike = info["isSelected"] as? Bool ?? false
                let likeCount = info["likeCount"] as? Int ?? 0

                let section = owner.viewModel.worksSections.value[0]
                
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
                owner.viewModel.worksSections.accept(newSections)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.completePost)
            .asSignal(onErrorRecover: { _ in .never() })
            .emit(with: self, onNext: { owner, notification in
                
                guard let category = notification.object as? WriteCategory else { return }
                
                guard (category == .request && owner.viewModel.isEmployment) ||
                        (category == .work && !owner.viewModel.isEmployment) else { return }
                
                owner.needRefresh = true
            })
            .disposed(by: disposeBag)
    }
    
    func bindInput() {
        mainView.writeButton.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    guard UserInfoManager.isLoggedIn else {
                        owner.showNeedLogIn()
                        return
                    }
                    
                    owner.viewModel.writeButtonTapped()
                })
            .disposed(by: disposeBag)
        
        mainView.worksCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let offset = 8.0 + (owner
                    .mainView
                    .worksCollectionView
                    .refreshControl?
                    .frame
                    .height ?? 0)
                owner.viewModel.refresh()
                owner
                    .mainView
                    .marketSkeletonView
                    .productCollectionView.snp.updateConstraints {
                        $0.top.equalTo(owner.mainView.categoryCollectionView.snp.bottom).offset(offset)
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
                    let selectedCategory: [WorksCategory] = indexPath == [0, 0] ?
                    [] :
                    selectedIndexPathes.map {
                        WorksCategory.allCases[$0.item]
                    }
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
                    let selectedCategory: [WorksCategory] = selectedIndexPathes.map {
                        WorksCategory.allCases[$0.item]
                    }
                    owner.viewModel.selectedCategory.accept(selectedCategory)
                    owner.viewModel.refresh()
                }
                
            })
            .disposed(by: disposeBag)
        
        mainView.worksCollectionView.rx.modelSelected(Products.self)
            .bind(with: self, onNext: { owner, products in
                let vm = DefaultProductsDetailVM(type: .request, refresh: owner.viewModel.refresh)
                let vc = ProductsDetailVC(id: products.id, type: .request, viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    
        mainView.worksCollectionView.rx.willBeginDragging
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.worksCollectionViewBeginDragging?.accept(true)
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
        
        let productSections = viewModel.worksSections
            .asDriver()
        
        productSections
            .drive(mainView.worksCollectionView.rx.items(dataSource: getProductDataSource()))
            .disposed(by: disposeBag)
        
        productSections
            .map { !$0[0].items.isEmpty }
            .distinctUntilChanged()
            .drive(mainView.nothingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // MARK: - 검색 옵션

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
                        owner.mainView.worksCollectionView.isHidden = true
                        owner.mainView.worksCollectionView.scroll(
                            to: .top,
                            animated: false
                        )
                    } else {
                        owner.mainView.worksCollectionView.isHidden = false
                        owner.view.hideSkeleton()
                        owner.mainView.marketSkeletonView.isHidden = true
                        
                        if owner.mainView.worksCollectionView.refreshControl?.isRefreshing ?? false {
                            owner
                                .mainView
                                .marketSkeletonView
                                .productCollectionView.snp.updateConstraints {
                                    $0.top.equalTo(owner.mainView.categoryCollectionView.snp.bottom)
                                }
                            owner.mainView.worksCollectionView.refreshControl?.endRefreshing()
                        }
                    }
                })
            .disposed(by: disposeBag)
    }
}

extension WorksVC: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == viewModel.worksSections.value[0].items.count - 2 {
            viewModel.fetchNextPage()
        }
    }
    
}

// MARK: - DataSouce

private extension WorksVC {
    func getCategoryDataSource() -> RxCollectionViewSectionedReloadDataSource<WorksCategorySection> {
        return RxCollectionViewSectionedReloadDataSource<WorksCategorySection>(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                guard let cell: CategoryTagCVC = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryTagCVC.identifier,
                    for: indexPath
                ) as? CategoryTagCVC else { return UICollectionViewCell() }

                if self.isViewDidLoad && item == .all {
                    collectionView.selectItem(
                        at: indexPath,
                        animated: false,
                        scrollPosition: .centeredHorizontally
                    )
                    self.isViewDidLoad = false
                }
                
                cell.updateWorksCell(category: item)
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
                    .work,
                    self.needLogIn,
                    self.currentTappedCell
                )
                return cell
            })
    }
}

// MARK: - Private Method

private extension WorksVC {
    func getCategoryCell(at indexPath: IndexPath) -> CategoryTagCVC {
        guard let cell = mainView
            .categoryCollectionView
            .cellForItem(at: indexPath) as? CategoryTagCVC else { return CategoryTagCVC() }
        return cell
    }
}

// MARK: - Configure Skeleton View

extension WorksVC: SkeletonCollectionViewDataSource {
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
