//
//  SignupGenreVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import RxSwift
import RxDataSources

final class SignupGenreVC: SZVC {
    // MARK: - Properties
    let mainView = SignupGenreView()
    var viewModel: SignupGenreVM

    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Init
    
    init(viewModel: SignupGenreVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.register(
            InterestedGenreCVC.self,
            forCellWithReuseIdentifier: InterestedGenreCVC.identifier
        )
        mainView.collectionView.register(
            InterestedGenreHeader.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: InterestedGenreHeader.identifier
        )
        bind()
    }
    func bind() {
        
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        mainView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let selectedIndexPath = owner.mainView.collectionView.indexPathsForSelectedItems
                if selectedIndexPath?.count == 4 {
                    owner.mainView.collectionView.deselectItem(at: indexPath, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        viewModel.allGenreSections
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.collectionView.rx.items(dataSource: getGenreDataSource()))
            .disposed(by: disposeBag)
    }
}

private extension SignupGenreVC {
    func getGenreDataSource() -> RxCollectionViewSectionedReloadDataSource<AllGenreDataSection> {
        return RxCollectionViewSectionedReloadDataSource(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: InterestedGenreCVC.identifier,
                    for: indexPath
                ) as? InterestedGenreCVC else { return UICollectionViewCell() }
                
                cell.textLabel.text = item.text
                return cell
            },
            configureSupplementaryView: { dataSourece, collectionView, kind, indexPath in
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: InterestedGenreHeader.identifier,
                    for: indexPath) as? InterestedGenreHeader else { return UICollectionReusableView() }
                
                header.titleLabel.text = dataSourece.sectionModels[indexPath.section].header
                
                return header
            }
        )
    }
}
