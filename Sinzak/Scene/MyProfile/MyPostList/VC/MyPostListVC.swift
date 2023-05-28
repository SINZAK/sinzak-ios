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

enum PostListType {
    case request
    case products
    case works
    
    var title: String {
        switch self {
        case .request:      return "의뢰해요"
        case .products:     return "판매 작품"
        case .works:        return "작업해요"
        }
    }
}

final class MyPostListVC: SZVC {
    
    private let mainView = MyPostListView()
    
    private let disposeBag = DisposeBag()
    
    private let type: DetailType
    private var products: [Products]
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - Init
    init(
        type: DetailType,
        products: [Products],
        postListType: PostListType
    ) {
        self.type = type
        self.products = products
        
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = postListType.title
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
    }
    
    // MARK: - Configure
    
    override func configure() {

        bind()
    }
}

// MARK: - Bind

private extension MyPostListVC {
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        mainView.productCollectionView.rx.modelSelected(Products.self)
            .bind(with: self, onNext: { owner, products in
                let refresh: () -> Void = {}
                let type = owner.type
                let vm = DefaultProductsDetailVM(
                    type: type,
                    refresh: refresh
                )
                let vc = ProductsDetailVC(
                    id: products.id,
                    type: type,
                    viewModel: vm
                )
                owner.navigationController?.pushViewController(
                    vc,
                    animated: true
                )
            })
            .disposed(by: disposeBag)

    }
    
    func bindOutput() {
        
        let dataSource = getProductDataSource()
        let section = Observable
            .just(
                [MarketProductDataSection(items: products)]
            )
            .share()
        
        section
            .bind(to: mainView.productCollectionView.rx.items(
                dataSource: dataSource)
            )
            .disposed(by: disposeBag)
        
        section
            .map { !$0[0].items.isEmpty }
            .distinctUntilChanged()
            .bind(to: mainView.nothingView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: - Data Source

private extension MyPostListVC {
    func getProductDataSource() -> RxCollectionViewSectionedReloadDataSource<MarketProductDataSection> {
        return RxCollectionViewSectionedReloadDataSource<MarketProductDataSection>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell: MyPostListCVC = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyPostListCVC.identifier,
                    for: indexPath
                ) as? MyPostListCVC else { return UICollectionViewCell() }
                
                cell.configCell(products: item)
                
                return cell
            })
    }
}
