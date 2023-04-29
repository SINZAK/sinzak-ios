//
//  DetailVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum DetailOwner {
    case mine
    case other
    var menus: [String] {
        switch self {
        case .mine:
            return ["수정하기", "삭제하기"]
        case .other:
            return ["신고하기", "님 차단하기"]
        }
    }
}
enum DetailType {
    case purchase
    case request
    var isSizeShown: Bool {
        switch self {
        case .purchase:
            return true
        case .request:
            return false
        }
    }
}
final class ProductsDetailVC: SZVC {
    // MARK: - Properties
    let id: Int
    
    let mainView = ProductsDetailView()
    let viewModel: ProductsDetailVM
    
    var owner: DetailOwner?
    var type: DetailType?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showAnimatedSkeleton(transition: .none)
        viewModel.fetchProductsDetail(id: id)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Init
    init(id: Int, type: DetailType, viewModel: ProductsDetailVM) {
        self.id = id
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func menuButtonTapped(_ sender: UIBarButtonItem) {
        // ActionSheet 띄우기
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let writerName = "신작" // 글작성자 이름
        owner = DetailOwner.other
        guard let owner = owner else { return }
        switch owner {
        case .mine:
            let edit = UIAlertAction(title: I18NStrings.edit, style: .default) { [weak self] _ in
                self?.editPost()
            }
            let remove = UIAlertAction(title: I18NStrings.remove, style: .default) { [weak self] _ in
                self?.removePost()
            }
            alert.addAction(edit)
            alert.addAction(remove)
        case .other:
            let report = UIAlertAction(title: I18NStrings.report, style: .default) { [weak self] _ in
                self?.reportUser()
            }
            let block = UIAlertAction(title: writerName + I18NStrings.blockUser, style: .default) { [weak self] _ in
                self?.blockUser()
            }
            alert.addAction(report)
            alert.addAction(block)
        }
        let cancel = UIAlertAction(title: I18NStrings.cancel, style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    /// 글 수정
    func editPost() {
        print("글 수정")
    }
    /// 글 삭제
    func removePost() {
        print("글 삭제")
    }
    /// 글 작성자 신고하기
    func reportUser() {
        print("신고")
    }
    /// 글 작성자 차단하기
    func blockUser() {
        print("차단")
    }
    /// 가격 제안하기
    @objc func priceOfferButtonTapped(_ sender: UIButton) {
        let vc = SendPriceOfferVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        view.isSkeletonable = true
        
        mainView.priceOfferButton.addTarget(self, action: #selector(priceOfferButtonTapped), for: .touchUpInside)
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        let menu = UIBarButtonItem(image: UIImage(named: "chatMenu"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItem = menu
    }
    
    // MARK: - bind
    
    func bind() {
        bindInput()
        bindOutput()

        mainView.imagePagerCollectionView.rx.didScroll
            .asDriver()
            .map { [weak self] _ -> Int in
                let width = UIScreen.main.bounds.width
                let currentPage = round((self?.mainView.imagePagerCollectionView.contentOffset.x ?? 0) / width)
                
                return Int(currentPage)
            }
            .distinctUntilChanged()
            .drive(mainView.pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
    
    func bindInput() {

    }
    
    func bindOutput() {
        viewModel.fetchedData
            .delay(
                .milliseconds(500),
                scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
            )
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, data in
                    owner.owner = data.myPost ? .mine : .other
                    owner.mainView.setData(data, owner.type)
                    owner.view.hideSkeleton()
                    owner.mainView.skeletonView.isHidden = true
                })
            .disposed(by: disposeBag)
        
        viewModel.imageSections
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.imagePagerCollectionView.rx.items(dataSource: getImageDataSource()))
            .disposed(by: disposeBag)
    }
}

private extension ProductsDetailVC {
    
    func getImageDataSource() -> RxCollectionViewSectionedReloadDataSource<ImageSection> {
        return RxCollectionViewSectionedReloadDataSource<ImageSection>(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                
                if item == "empty" {
                    Log.debug("empty")
                    self.mainView.pageControl.isHidden = true
                }
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCVC.identifier,
                    for: indexPath
                ) as? PhotoCVC else { return UICollectionViewCell() }
                cell.setImage(item)
                return cell
            })
    }
}
