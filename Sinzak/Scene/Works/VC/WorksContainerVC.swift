//
//  WorksContainerVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WorksContainerVC: SZVC {
    
    private let disposeBag = DisposeBag()
    
    private var worksMode: WorksMode
    
    private let worksTabVC: WorksTabVC
    
    private var worksCollectionViewBeginDragging: PublishRelay<Bool>?
    private var searchButtonTapped: BehaviorRelay<(isEmployment: Bool, text: String)>?
        
    private let alignButton = UIButton().then {
        $0.setImage(UIImage(named: "align"), for: .normal)
        $0.setTitle("신작추천순", for: .normal)
        $0.titleLabel?.font = .caption_B
        $0.setTitleColor(CustomColor.gray80, for: .normal)
        $0.tintColor = CustomColor.gray80
    }
    
    private let searchBarButton = UIBarButtonItem(
        image: UIImage(named: "search"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "의뢰 및 작업 통합 검색"
        searchBar.tintColor = CustomColor.red
        
        return searchBar
    }()

    // MARK: - Init
    
    init(worksMode: WorksMode) {
        self.worksMode = worksMode
        self.worksTabVC = WorksTabVC(worksMode: worksMode)
        self.worksCollectionViewBeginDragging = worksTabVC.worksCollectionViewBeginDragging
        self.searchButtonTapped = worksTabVC.searchButtonTapped
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        
        navigationItem.title = "의뢰"
        navigationItem.rightBarButtonItem = searchBarButton
    }
    
    override func configure() {
        super.configure()
        
        addChild(worksTabVC)
        view.addSubview(worksTabVC.view)
        
        worksTabVC.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(alignButton)
        view.bringSubviewToFront(alignButton)
        
        alignButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.0)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        if worksMode == .search {
            alignButton.isHidden = true
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView = searchBar
        }

        bind()
    }
    
    private func bind() {
        worksTabVC.alignInfoRelay
            .map { $0.align.text }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(alignButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        alignButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let vc = WorksSelectAlignVC(with: owner.worksTabVC.alignInfoRelay)
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                owner.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
           .subscribe(onNext: { [weak self] in
               let vc = WorksContainerVC(worksMode: .search)
               self?.navigationController?.pushViewController(vc, animated: true)
           })
           .disposed(by: disposeBag)
        
        worksCollectionViewBeginDragging?
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.searchBar.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let text = owner.searchBar.text ?? ""
                if text.count < 2 {
                    owner.showSinglePopUpAlert(message: "2글자 이상 입력해 주세요.")
                    return
                }
                owner.searchButtonTapped?.accept((
                    isEmployment: owner.worksTabVC.alignInfoRelay.value.isEmployment,
                    text: text
                ))
            })
            .disposed(by: disposeBag)
    }
}
