//
//  ScrapListVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SkeletonView

final class ScrapListVC: SZVC {
    
    private let viewModel: ScrapListVM
    private let mainView = ScrapListView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - Init
    init(viewModel: ScrapListVM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        viewModel.fetchScrapList()
    }
    
    // MARK: - Configure
    
    override func configure() {
        mainView.marketSkeletonView.productCollectionView.dataSource = self
        view.isSkeletonable = true
        
        bind()
    }

    override func setNavigationBar() {
        super.setNavigationBar()
        
        navigationItem.title = "스크랩 목록"
    }
    
}

// MARK: - Bind

private extension ScrapListVC {
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
    
    }
    
    func bindOutput() {
        
        let dataSource = getProductDataSource()
        let productsSection = viewModel.productSections
            .asDriver()
        
        productsSection
            .drive(mainView.productCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        productsSection
            .skip(1)
            .map { !$0[0].items.isEmpty }
            .distinctUntilChanged()
            .drive(mainView.nothingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isShowSkeleton
            .asSignal()
            .emit(with: self, onNext: { owner, isShow in
                switch isShow {
                case true:
                    owner.mainView.marketSkeletonView.isHidden = false
                    owner.view.showAnimatedSkeleton()
                case false:
                    owner.mainView.marketSkeletonView.isHidden = true
                    owner.view.hideSkeleton()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Data Source

private extension ScrapListVC {
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
                    nil
                )
                cell.setScrapList()
                return cell
            })
    }
}

// MARK: - Configure Skeleton View

extension ScrapListVC: SkeletonCollectionViewDataSource {
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
