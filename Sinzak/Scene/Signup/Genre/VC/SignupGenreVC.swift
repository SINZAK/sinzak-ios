//
//  SignupGenreVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import RxSwift

final class SignupGenreVC: SZVC {
    // MARK: - Properties
    let mainView = SignupGenreView()
    let genreList = Genre.list
    var viewModel = SignupViewModel()
    var userSelect: [[Int]] = [[],[]] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Actions
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.collectionViewLayout = setLayout()
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(InterestedGenreCVC.self, forCellWithReuseIdentifier: String(describing: InterestedGenreCVC.self))
        mainView.collectionView.register(InterestedGenreHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: String(describing: InterestedGenreHeader.self))
        bind()
    }
    func bind() {
        mainView.nextButton.rx.tap
            .bind { [unowned self] _ in
                var genre = Array<String>()
                for (section, datas) in userSelect.enumerated() {
                    for item in datas {
                        genre.append(genreList[section].category[item].rawValue)
                    }
                }
                viewModel.joinInfo.categoryLike = genre.map { $0 }.joined(separator: ",")
                // 회원가입 시키기
                debugPrint(viewModel.joinInfo)
                AuthManager.shared.join(viewModel.joinInfo) { result in
                    if result {
                        let vc = UniversityInfoVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        debugPrint(result)
                        showAlert(title: "ERROR: 회원가입에 실패하였습니다. 다시 시도해주세요.", okText: "확인", cancelNeeded: false, completionHandler: nil)
                    }
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
}

extension SignupGenreVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return genreList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreList[section].category.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InterestedGenreCVC.self), for: indexPath) as? InterestedGenreCVC else { return UICollectionViewCell()}
        cell.textLabel.text = genreList[indexPath.section].category[indexPath.item].text
       let bool =  userSelect[indexPath.section].contains(indexPath.item)
        cell.isUserSelected(bool)
        return cell
    }
    // 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택할 수 있는 최대갯수 = 3
        if userSelect[indexPath.section].contains(indexPath.item) {
            let index = userSelect[indexPath.section].firstIndex(of: indexPath.item)
            userSelect[indexPath.section].remove(at: index!)
        } else {
            if userSelect[0].count + userSelect[1].count == 3 {
                showAlert(title: "최대 3개까지 선택할 수 있습니다.", okText: I18NStrings.confirm, cancelNeeded: false, completionHandler: nil)
            } else {
                userSelect[indexPath.section].append(indexPath.item)
            }
        }
    }
    // 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: InterestedGenreHeader.self), for: indexPath) as? InterestedGenreHeader else { return UICollectionReusableView() }
        header.titleLabel.text = genreList[indexPath.section].type
        return header
    }
}

extension SignupGenreVC {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 5, bottom: 5, trailing: 8)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(130)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
         
        section.interGroupSpacing = 8
        
        let headerItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(30))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 19
        layout.configuration = config
        return layout
    }
}
