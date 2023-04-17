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
//        mainView.nextButton.rx.tap
//            .withUnretained(self)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { owner, _ in
//                let vc = UniversityInfoVC(viewModel: DefaultUniversityInfoVM())
//                owner.navigationController?.pushViewController(vc, animated: true)
//            })
//            .disposed(by: viewModel.disposeBag)

            // TODO: 선택한거 저장, 회원가입 로직이동해야함
//            .bind { [weak self]  _ in
//                guard let self = self else { return }
//                let vc = StudentAuthVC()
//                self.navigationController?.pushViewController(vc, animated: true)
                
//                var genre = [String]()
//                for (section, datas) in userSelect.enumerated() {
//                    for item in datas {
//                        genre.append(genreList[section].category[item].rawValue)
//                    }
//                }
                
//                viewModel.joinInfo.categoryLike = genre.map { $0 }.joined(separator: ",")
//                // 회원가입 시키기
//                debugPrint(viewModel.joinInfo)
//                AuthManager.shared.join(viewModel.joinInfo) { [weak self] result in
//                    guard let self = self else { return }
//                    if result {
//                        let vc = UniversityInfoVC()
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    } else {
//                        debugPrint(result)
//                        self.showAlert(
//                            title: "ERROR: 회원가입에 실패하였습니다. 다시 시도해주세요.",
//                            okText: "확인",
//                            cancelNeeded: false,
//                            completionHandler: nil
//                        )
//                    }
//                }
//            }
        
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
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

/*
extension SignupGenreVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return genreList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return genreList[section].category.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: InterestedGenreCVC.self),
            for: indexPath
        ) as? InterestedGenreCVC else { return UICollectionViewCell()}
        
        cell.textLabel.text = genreList[indexPath.section].category[indexPath.item].text
       let bool = userSelect[indexPath.section].contains(indexPath.item)
        cell.isUserSelected(bool)
        return cell
    }
    // 선택했을 때
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // 선택할 수 있는 최대갯수 = 3
        if userSelect[indexPath.section].contains(indexPath.item) {
            let index = userSelect[indexPath.section].firstIndex(of: indexPath.item)
            userSelect[indexPath.section].remove(at: index!)
        } else {
            if userSelect[0].count + userSelect[1].count == 3 {
                showAlert(
                    title: "최대 3개까지 선택할 수 있습니다.",
                    okText: I18NStrings.confirm,
                    cancelNeeded: false,
                    completionHandler: nil
                )
            } else {
                userSelect[indexPath.section].append(indexPath.item)
            }
        }
    }
    
    // 헤더
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: InterestedGenreHeader.self),
            for: indexPath
        ) as? InterestedGenreHeader else { return UICollectionReusableView() }
        header.titleLabel.text = genreList[indexPath.section].type
        return header
    }
}

*/
