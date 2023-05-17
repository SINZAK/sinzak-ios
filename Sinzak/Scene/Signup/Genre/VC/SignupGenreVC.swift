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
    let mode: EditViewMode
    var viewModel: SignupGenreVM
    
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .editProfile {
            configEditProfileMode()
        }
    }
    
    // MARK: - Init
    
    init(viewModel: SignupGenreVM, mode: EditViewMode) {
        self.viewModel = viewModel
        self.mode = mode
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
                guard let selectedIndexPath = owner.mainView.collectionView.indexPathsForSelectedItems else {
                    return
                }
                if selectedIndexPath.count == 4 {
                    owner.mainView.collectionView.deselectItem(at: indexPath, animated: false)
                } else {
                    let selectedGenre: [AllGenre] = selectedIndexPath
                        .map { indexPath in
                            guard let cell = owner.mainView.collectionView.cellForItem(at: indexPath) as? InterestedGenreCVC else { return .label }
                            return cell.allGenre ?? .label
                        }
                    owner.viewModel.selectedGenre.accept(selectedGenre)
                    Log.debug(owner.viewModel.selectedGenre.value)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.itemDeselected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let selectedIndexPath = owner.mainView.collectionView.indexPathsForSelectedItems else {
                    return
                }
                let selectedGenre: [AllGenre] = selectedIndexPath
                    .map { indexPath in
                        guard let cell = owner.mainView.collectionView.cellForItem(at: indexPath) as? InterestedGenreCVC else { return .label }
                        return cell.allGenre ?? .label
                    }
                owner.viewModel.selectedGenre.accept(selectedGenre)
                Log.debug(owner.viewModel.selectedGenre.value)
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                switch owner.mode {
                case .signUp:
                    owner.viewModel.tapNextButton()
                case .editProfile:
                    owner.showLoading()
                    owner.viewModel.tapUpdateGenreButton()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        viewModel.allGenreSections
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.collectionView.rx.items(dataSource: getGenreDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.pushUniversityInfoView
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, vc in
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.completeUpdateGenre
            .asSignal()
            .emit(with: self, onNext: { owner, _ in
                owner.hideLoading()
                owner.dismiss(animated: true)
            })
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
                
                cell.configureCell(with: item)
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
    
    func configEditProfileMode() {
        guard mode == .editProfile else { return }
        
        let dismissBarButton = UIBarButtonItem(
            image: SZImage.Icon.dismiss,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem = dismissBarButton
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.dismiss(animated: true)
                })
            .disposed(by: disposeBag)
        
        navigationItem.title = "관심장르 변경"
        
        mainView.titleLabel.isHidden = true
        mainView.descriptionLabel.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(32.0)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24.0)
        }
        
        mainView.nextButton.setTitle("확인", for: .normal)
    }
}
