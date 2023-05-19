//
//  WriteCategoryVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum WriteCategorySections: Int, CaseIterable {
    case genre = 0
    case category
}

final class WriteCategoryVC: SZVC {
    // MARK: - Properties
    private let mainView = WriteCategoryView()
    private let viewModel: WriteCategoryVM
    private let disposeBag = DisposeBag()
    private let initialSelection: WriteCategory
    
    // MARK: - Helpers
    override func loadView() {
        view = mainView
    }
    
    init(viewModel: WriteCategoryVM, initialSelection: WriteCategory) {
        self.viewModel = viewModel
        self.initialSelection = initialSelection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad(initialSelection: initialSelection)
        
        mainView.categoryCollectionView.selectItem(
            at: [0, initialSelection.item],
            animated: false,
            scrollPosition: []
        )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Actions
    @objc private func nextButtonTapped(_ sender: UIButton) {
        let vc = WritePostVC(viewModel: DefaultAddPhotosVM())
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.categorySelection
        
        let dismissBarButton = UIBarButtonItem(
            image: SZImage.Icon.dismiss,
            style: .plain,
            target: nil,
            action: nil
        )
        let nextBarButton = UIBarButtonItem(
            title: "다음",
            style: .plain,
            target: nil,
            action: nil
        )
        nextBarButton.setTitleTextAttributes(
            [
                .foregroundColor: CustomColor.alertTint2,
                .font: UIFont.body_M
            ],
            for: .normal
        )
        
        navigationItem.leftBarButtonItem = dismissBarButton
        navigationItem.rightBarButtonItem = nextBarButton
    }
}

// MARK: - Bind
private extension WriteCategoryVC {
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        mainView.categoryCollectionView.rx.modelSelected(WriteCategory.self)
            .withUnretained(self)
            .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .subscribe(onNext: { owner, category in
                owner.viewModel.categoryCellTapped(category)
            })
            .disposed(by: disposeBag)
        
        mainView.genreCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                
                let selectedCount = owner
                    .viewModel
                    .selectedGenres
                    .value
                    .count
                
                if selectedCount == 3 {
                    owner
                        .mainView
                        .genreCollectionView
                        .deselectItem(at: indexPath, animated: false)
                    return
                }
                
                let selectedItems = owner
                    .mainView
                    .genreCollectionView
                    .indexPathsForSelectedItems ?? []
                
                owner.viewModel.genreCellTapped(selectedItems)
            })
            .disposed(by: disposeBag)
        
        mainView.genreCollectionView.rx.itemDeselected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                
                let selectedItems = owner
                    .mainView
                    .genreCollectionView
                    .indexPathsForSelectedItems ?? []
                
                owner.viewModel.genreCellTapped(selectedItems)
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.dismiss(animated: true)
                })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    let vc = WritePostVC(viewModel: DefaultAddPhotosVM())
                    owner.navigationController?.pushViewController(vc, animated: true)
                })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
        let writeCategoryDataSource = getWriteCategoryDataSource()
        viewModel.writeCategorySections
            .bind(to: mainView.categoryCollectionView.rx.items(dataSource: writeCategoryDataSource))
            .disposed(by: disposeBag)
        
        let genreDataSource = getGenreDataSource()
        viewModel.genreSections
            .bind(to: mainView.genreCollectionView.rx.items(dataSource: genreDataSource))
            .disposed(by: disposeBag)
        
        viewModel.selectedGenres
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .drive((navigationItem.rightBarButtonItem?.rx.isEnabled)!)
            .disposed(by: disposeBag)
    }
}

private extension WriteCategoryVC {
    
    func getWriteCategoryDataSource() -> RxCollectionViewSectionedReloadDataSource<WriteCategorySection> {
        return RxCollectionViewSectionedReloadDataSource(
            configureCell: { _, collectionView, indexPath, item in
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WriteCategoryCVC.identifier,
                    for: indexPath
                ) as? WriteCategoryCVC else { return UICollectionViewCell() }
                
                cell.updateCell(kind: item)
                return cell
            },
            
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: WriteCategoryHeader.identifier,
                    for: indexPath
                ) as? WriteCategoryHeader else { return UICollectionReusableView()}
                
                header.update(kind: WriteCategoryHeaderKind.selectGenre)
                
                return header
            })
    }
    
    func getGenreDataSource() -> RxCollectionViewSectionedReloadDataSource<GenreSection> {
        return RxCollectionViewSectionedReloadDataSource(
            configureCell: { _, collectionView, indexPath, item in
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: InterestedGenreCVC.identifier,
                    for: indexPath
                ) as? InterestedGenreCVC else { return UICollectionViewCell() }
                
                switch item {
                case .products(let productsCategory):
                    cell.configurePostProductsCell(with: productsCategory)
                case .works(let worksCategory):
                    cell.configurePostWorksCell(with: worksCategory)
                }
                
                return cell
            },
            
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: WriteCategoryHeader.identifier,
                    for: indexPath
                ) as? WriteCategoryHeader else { return UICollectionReusableView()}
                
                header.update(kind: WriteCategoryHeaderKind.selectCategory)
                
                return header
            })
    }
}
