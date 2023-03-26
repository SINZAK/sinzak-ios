//
//  UniversityInfoVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import RxSwift

final class UniversityInfoVC: SZVC {
    // MARK: - Properties
    private let mainView = UniversityInfoView()
    var viewModel = SchoolAuthViewModel()
    var schoolList: [String] = []
    var filteredData: [String] = [] {
        didSet {
            self.configureDataSource()
        }
    }
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolList = SchoolList.loadJson()!.school.flatMap { $0.koreanName }
    }
    // MARK: - Actions
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.collectionViewLayout = setLayout()
        mainView.collectionView.register(UniversityAutoCompletionCVC.self, forCellWithReuseIdentifier: String(describing: UniversityAutoCompletionCVC.self))
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.leftBarButtonItem = nil // 이미 가입이 끝난 상황이라 뒤로 돌아가면 안됨
    }
    func bind() {
        let input = SchoolAuthViewModel.Input(queryText: mainView.searchTextField.rx.text, nextButtonTap: mainView.nextButton.rx.tap, notStudentButtonTap: mainView.notStudentButton.rx.tap)
        let output = viewModel.transform(input: input)
        output.nextButtonTap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.univEmailModel.univName = self.mainView.searchTextField.text ?? ""
                let vc = StudentAuthVC()
                vc.viewModel = self.viewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        output.notStudentButtonTap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let vc = WelcomeVC()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        output.queryText
            .bind { [weak self] query in
                guard let self = self else { return }
                if query.count > 0 {
                    self.filteredData.removeAll(keepingCapacity: false)
                    let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", query)
                    let array = (self.schoolList as NSArray).filtered(using: searchPredicate)
                    self.filteredData = array as! [String]
                    print(self.filteredData)
                    /// 이제 검색목록을 뷰에 뿌리기
                    if !self.filteredData.isEmpty {
                        self.mainView.collectionView.isHidden = false
                    } else {
                        self.mainView.collectionView.isHidden = true
                    }
                } else {
                    self.filteredData.removeAll(keepingCapacity: false)
                    self.mainView.collectionView.isHidden = true
                }
            }.disposed(by: viewModel.disposeBag)
    }
}
// collection view
extension UniversityInfoVC: UICollectionViewDelegate {
    // 콜렉션 뷰 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UniversityAutoCompletionCVC.self), for: indexPath) as? UniversityAutoCompletionCVC else { return UICollectionViewCell() }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filteredData.count >= indexPath.item {
            mainView.searchTextField.text = filteredData[indexPath.item]
        }
    }
}

extension UniversityInfoVC {
    private func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    /// data source
    private func configureDataSource() {
        // Cell Registration
        let cellRegistration =  UICollectionView.CellRegistration<UICollectionViewListCell, String>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.textProperties.font = .caption_B
            
            content.text = itemIdentifier
            cell.contentConfiguration = content
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .clear
            cell.backgroundConfiguration = background
        })
        // Diffable Data Source
        // collectionView.dataSource = self 코드의 대체
        // CellForItemAt 대체
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration , for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        // 스냅샷, 모델을 Initialise 해줄 것
        // 스냅샷 타입은 위에 dataSource형태와 맞추기 (섹션Int, 모델타입)
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredData, toSection: 0 )
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
