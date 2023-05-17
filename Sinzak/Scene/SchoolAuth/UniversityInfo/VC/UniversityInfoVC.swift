//
//  UniversityInfoVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import RxSwift
import RxKeyboard
import RxDataSources

enum EditViewMode {
    case signUp
    case editProfile
}

final class UniversityInfoVC: SZVC {
    // MARK: - Properties
    private let mainView = UniversityInfoView()
    var viewModel: UniversityInfoVM
    var mode: EditViewMode
    
    private let disposeBag = DisposeBag()
       
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Init
    init(viewModel: UniversityInfoVM, mode: EditViewMode) {
        self.viewModel = viewModel
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        viewModel.isHideCollectionView.accept(true)
        view.endEditing(true)
    }
        
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.collectionViewLayout = setLayout()
        mainView.collectionView.register(
            UniversityAutoCompletionCVC.self,
            forCellWithReuseIdentifier: UniversityAutoCompletionCVC.identifier
        )
        bind()
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        
        switch mode {
        case .signUp:
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = nil

        case .editProfile:
            let dismissBarButton = UIBarButtonItem(
                image: SZImage.Icon.dismiss,
                style: .plain,
                target: nil,
                action: nil
            )
            navigationItem.leftBarButtonItem = dismissBarButton
        }
    }
    
    // MARK: - Bind
    func bind() {
        
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        mainView.searchTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                if text.isEmpty {
                    owner.viewModel.isEnableNextButton.accept(false)
                } else {
                    owner.viewModel.isEnableNextButton.accept(true)
                }
                owner.viewModel.textFieldInput(text)
            })
            .disposed(by: disposeBag)
        
        mainView.searchTextField.rx.controlEvent(.editingDidBegin)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if !(owner.mainView.searchTextField.text?.isEmpty ?? true) {
                    owner.viewModel.isHideCollectionView.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.mainView.collectionView.cellForItem(at: indexPath) as? UniversityAutoCompletionCVC else {
                    return
                }
                self?.mainView.searchTextField.text = cell.textLabel.text
                self?.view.endEditing(true)
                self?.viewModel.isHideCollectionView.accept(true)
            })
            .disposed(by: disposeBag)
        
        mainView.notStudentButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                switch owner.mode {
                case .signUp:
                    owner.viewModel.tapNotStudentButton()
                case .editProfile:
                    owner.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let univName = owner.mainView.searchTextField.text ?? ""
                owner.viewModel.tapNextButton(
                    univName: univName,
                    mode: owner.mode
                )
            })
            .disposed(by: disposeBag)
                    
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeignt in
                guard let self = self else { return }
                if keyboardVisibleHeignt > 0 {
                    
                    self.mainView.buttonStack.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(keyboardVisibleHeignt + 16.0)
                    }
                    self.view.layoutIfNeeded()
                    
                } else {
                    self.mainView.buttonStack.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(24.0)
                    }
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.dismiss(animated: true)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
        viewModel.isHideCollectionView
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] in
                if $0 {
                    self?.mainView.collectionView.hideViewAnimate()
                    self?.viewModel.isHideNoAutoMakeLabel.accept(true)
                } else {
                    self?.mainView.collectionView.showViewAnimate()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.schoolSections
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.collectionView.rx.items(dataSource: getSchoolDataSoure()))
            .disposed(by: disposeBag)
        
        viewModel.isHideNoAutoMakeLabel
            .asDriver(onErrorJustReturn: true)
            .drive(mainView.noAutoMakeLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isEnableNextButton
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.presentWelcomeView
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, vc in
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushStudentAuthView
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, vc in
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension UniversityInfoVC {
    private func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(36)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

// MARK: - Data Source
private extension UniversityInfoVC {
    func getSchoolDataSoure() -> RxCollectionViewSectionedReloadDataSource<SchoolDataSection> {
        return RxCollectionViewSectionedReloadDataSource<SchoolDataSection> { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UniversityAutoCompletionCVC.identifier,
                for: indexPath
            ) as? UniversityAutoCompletionCVC else { return UICollectionViewCell() }
            
            let text = item.school.koreanName
            cell.textLabel.text = text
            let color: UIColor = CustomColor.red ?? .red
            let attributedString = NSMutableAttributedString(string: cell.textLabel.text ?? "")
            attributedString.addAttribute(
                .foregroundColor,
                value: color,
                range: (text as NSString).range(of: self.viewModel.currentInputText)
            )
            cell.textLabel.attributedText = attributedString
            
            return cell
        }
    }
}
