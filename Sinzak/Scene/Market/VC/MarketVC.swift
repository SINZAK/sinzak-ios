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
    private let viewModel: MarketVM!
    private let mainView = MarketView()
    let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    
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
        viewModel.viewDidLoad()
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
        bind()
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
        
        mainView.viewOptionButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let current = self?.viewModel.isSaling.value ?? false
                self?.viewModel.isSaling.accept(!current)
            })
            .disposed(by: disposeBag)
        
        mainView.alignButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.alignButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.productCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedCategory
            .observe(on: backgroundScheduler)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        viewModel.isSaling
            .observe(on: backgroundScheduler)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        viewModel.currentAlign
            .observe(on: backgroundScheduler)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        mainView.categoryCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectCategory(with: indexPath)
            })
            .disposed(by: disposeBag)
        
        mainView.categoryCollectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectCategory(with: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
    
        // MARK: - 화면이동
        viewModel.pushWriteCategoryVC
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushSerachVC
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
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
        
        viewModel.presentSkeleton
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vc in
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: false)
            })
            .disposed(by: disposeBag)
            
        // MARK: - Collection View Section
        viewModel.categorySections
            .bind(to: mainView.categoryCollectionView.rx.items(dataSource: getCategoryDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.productSections
            .bind(to: mainView.productCollectionView.rx.items(dataSource: getProductDataSource()))
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
        
        viewModel.currentAlign
            .asDriver(onErrorJustReturn: .recommend)
            .drive(onNext: { [weak self] alignOption in
                guard let self = self else { return }
                self.mainView.alignButton.setTitle(alignOption.text, for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.endRefresh
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] in
                if $0 {
                    self?.mainView.productCollectionView.refreshControl?.endRefreshing()
                    self?.mainView.productCollectionView.setContentOffset(.zero, animated: false)
                }
            })
            .disposed(by: disposeBag)
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
                if self.viewModel.selectedCategory.value.isEmpty && item.category == .all {
                    cell.isChecked = true
                }
                cell.updateCell(category: item.category)
                
                return cell
            })
    }
    
    func getProductDataSource() -> RxCollectionViewSectionedReloadDataSource<MarketProductDataSection> {
        return RxCollectionViewSectionedReloadDataSource<MarketProductDataSection>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell: ArtCVC = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ArtCVC.identifier,
                    for: indexPath
                ) as? ArtCVC else { return UICollectionViewCell() }
                cell.setData(item)
                return cell
            })
    }
}

// MARK: - ViewControllerTransitioning

extension MarketVC: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        SelectAlignPC(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

// MARK: - Private Method

private extension MarketVC {
    
    func selectCategory(with indexPath: IndexPath) {
        var currentCategories: [Category] = viewModel.selectedCategory.value
        let selectedCell = getCategoryCell(at: indexPath)
        
        if selectedCell.category == .all {
            if selectedCell.isChecked { return }
            (1..<Category.allCases.count)
                .forEach {
                    let notAllCell = getCategoryCell(at: IndexPath(item: $0, section: 0))
                    notAllCell.isChecked = false
                    currentCategories = []
                }
        } else {
           
            if selectedCell.isChecked {
                currentCategories.remove(at: currentCategories.firstIndex(of: selectedCell.category!)!)
                if currentCategories.isEmpty {
                    let firstCell = getCategoryCell(at: IndexPath(item: 0, section: 0))
                    firstCell.isChecked = true
                }
            } else {
                guard currentCategories.count <= 2 else { return }
                guard let firstCell = mainView
                    .categoryCollectionView
                    .cellForItem(at: IndexPath(item: 0, section: 0)) as? CategoryTagCVC else { return }
                firstCell.isChecked = false
                currentCategories.append(selectedCell.category ?? .all)
            }
        }
        
        Log.debug(currentCategories)
        viewModel.selectedCategory.accept(currentCategories)
        selectedCell.isChecked = !selectedCell.isChecked
    }
    
    func getCategoryCell(at indexPath: IndexPath) -> CategoryTagCVC {
        guard let cell = mainView
            .categoryCollectionView
            .cellForItem(at: indexPath) as? CategoryTagCVC else { return CategoryTagCVC() }
        return cell
    }
}
