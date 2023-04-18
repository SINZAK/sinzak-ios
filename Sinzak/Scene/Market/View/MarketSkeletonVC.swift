//
//  MarketSkeletonVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/08.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

final class MarketSkeletonVC: SZVC {
    
    // MARK: - Porperty
    
    private let productSections: BehaviorRelay<[MarketProductDataSection]>
    private let align: AlignOption
    private let category: [Category]
    private let page: Int
    private let size: Int
    private let sale: Bool
    
    private let categoryDataSource: [Category] = Category.allCases
    
    private let productDataSource: [MarketProduct] = [
        MarketProduct.init(
            id: 0,
            title: "skeleton",
            content: "",
            author: "skeletonskeleton",
            price: 30000,
            thumbnail: "skeleton",
            date: "skeleton",
            suggest: false,
            like: false,
            likesCnt: 100,
            complete: false,
            popularity: 0
        )
    ]
    
    // MARK: - UI
    
    private lazy var categoryFlowLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.0
        layout.estimatedItemSize = CGSize(width: 80, height: 30.0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        
        return layout
    }()
    
    private lazy var categoryCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: categoryFlowLayout
    ).then {
        $0.register(
            CategoryTagCVC.self,
            forCellWithReuseIdentifier: CategoryTagCVC.identifier
        )
        $0.backgroundColor = .clear
        $0.isSkeletonable = true
    }
    
    private lazy var productFlowLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: (view.frame.width - 48.0) / 2, height: 256.0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        
        return layout
    }()
    
    private lazy var productCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: productFlowLayout
    ).then {
        $0.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )
        $0.allowsMultipleSelection = true
        $0.backgroundColor = .clear
        $0.isSkeletonable = true
    }
    
    private let viewOptionLabel = UILabel().then {
        $0.text = "  판매중 작품만 보기"
        $0.isSkeletonable = true
    }
    
    private let alignLabel = UILabel().then {
        $0.text = "  신작추천순"
        $0.isSkeletonable = true
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
//        let skeletonAnimation = SkeletonAnimationBuilder()
//        view.showAnimatedGradientSkeleton(
//            usingGradient: .init(colors: [.lightGray, .gray]),
//            animation: skeletonAnimation,
//            transition: .none
//        )
        view.showAnimatedSkeleton()
        
        ProductsManager.shared.fetchProducts(
            align: align,
            category: category,
            page: page,
            size: size,
            sale: sale
        )
        .delay(
            .milliseconds(1000),
            scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
        )
        .subscribe(
            onSuccess: { [weak self] products in
                Log.debug("Thread: \(Thread.current)")
                guard let self = self else { return }
                let newSectionModel: [MarketProductDataSection] = [
                    MarketProductDataSection(items: products)
                ]
                self.productSections.accept(newSectionModel)
                DispatchQueue.main.async {
                    self.view.hideSkeleton()
                    self.dismiss(animated: false)
                }
            },
            onFailure: { error in
                if error is APIError {
                    let apiError = error as? APIError
                    Log.debug(apiError?.info ?? "")
                }
                self.view.hideSkeleton()
                self.dismiss(animated: false)
            }
        )
        .disposed(by: disposeBag)
    }
    
    // MARK: - Init
    init(
        productSections: BehaviorRelay<[MarketProductDataSection]>,
        align: AlignOption,
        category: [Category],
        page: Int,
        size: Int,
        sale: Bool
    ) {
        self.productSections = productSections
        self.align = align
        self.category = category
        self.page = page
        self.size = size
        self.sale = sale
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        
        view.isSkeletonable = true
        
        categoryCollectionView.tag = 1
        productCollectionView.tag = 2
        
        categoryCollectionView.dataSource = self
        productCollectionView.dataSource = self
        
        configureLayout()
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "마켓"
    }
    
    func configureLayout() {
        [
            categoryCollectionView,
            viewOptionLabel,
            alignLabel,
            productCollectionView
        ].forEach { view.addSubview($0) }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56.0)
        }
        
        viewOptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18.0)
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8.0)
        }
    
        alignLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8.0)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(alignLabel.snp.bottom).offset(8.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MarketSkeletonVC: SkeletonCollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView.tag == 1 {
            return 8
        } else {
            return 15
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let cell: CategoryTagCVC = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryTagCVC.identifier,
                for: indexPath
            ) as? CategoryTagCVC else { return UICollectionViewCell() }
            cell.tagBackgroundView.layer.borderWidth = 0.0
            
            return cell
        } else {
            guard let cell: ArtCVC = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArtCVC.identifier,
                for: indexPath
            ) as? ArtCVC else { return UICollectionViewCell() }
            cell.setData(productDataSource[0])
            cell.setSkeleton()
            
            return cell
        }
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> SkeletonView.ReusableCellIdentifier {
        if skeletonView.tag == 1 {
            return CategoryTagCVC.identifier
        } else {
            return ArtCVC.identifier
        }
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        skeletonCellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell? {
        if skeletonView.tag == 1 {
            guard let cell: CategoryTagCVC = skeletonView.dequeueReusableCell(
                withReuseIdentifier: CategoryTagCVC.identifier,
                for: indexPath
            ) as? CategoryTagCVC else { return UICollectionViewCell() }
            cell.tagBackgroundView.layer.borderWidth = 0.0

            return cell
        } else {
            guard let cell: ArtCVC = skeletonView.dequeueReusableCell(
                withReuseIdentifier: ArtCVC.identifier,
                for: indexPath
            ) as? ArtCVC else { return UICollectionViewCell() }
            cell.setData(productDataSource[0])
            cell.setSkeleton()
            
            return cell
        }
    }
}

//extension MarketSkeletonVC: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        <#code#>
//    }
//
//}
