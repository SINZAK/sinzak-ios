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
    
    private let disposeBag = DisposeBag()
    
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
        self.type = type
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
 
    /// 글 수정
    func editPost() {
        print("글 수정")
    }
    /// 글 삭제
    @objc
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
        let menu = UIBarButtonItem(
            image: UIImage(named: "chatMenu"),
            style: .plain,
            target: nil,
            action: nil
        )
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
        
        navigationItem.rightBarButtonItem?.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if !UserInfoManager.isLoggedIn {
                    owner.needLogIn.accept(true)
                    return
                }
                
                if owner.owner == .mine {
                    owner.showDoubleAlertSheet(
                        firstActionText: "수정하기",
                        secondActionText: "삭제하기",
                        firstCompletion: {
                            // TODO: 수정 화면으로 이동
                        },
                        secondCompletion: {
                            
                            owner.showPopUpAlert(
                                message: "정말 게시글을 삭제할까요?",
                                rightActionTitle: "네, 삭제할게요",
                                rightActionCompletion: {
                                    owner.showLoading()
                                    ProductsManager.shared.deleteProducts(id: owner.id)
                                        .observe(on: MainScheduler.instance)
                                        .subscribe(onSuccess: { _ in
                                            
                                            owner.navigationController?.popViewController(animated: true)
                                            owner.hideLoading()
                                            owner.viewModel.refresh()
                                        })
                                        .disposed(by: owner.disposeBag)
                                })
                        }
                    )
                }
                
                if owner.owner == .other {
                    owner.showSingleAlertSheet(
                        actionTitle: "신고하기",
                        completion: {
                            let vc = ReportSelectVC(
                                userID: owner.mainView.products?.userID ?? 0,
                                userName: owner.mainView.products?.author ?? ""
                            )
                            owner.navigationController?.pushViewController(vc, animated: true)
                        })
                }
                
            })
            .disposed(by: disposeBag)
        
        mainView.isCompleteButton.rx.tap
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in

                    if owner.owner == .other || owner.mainView.isComplete { return }
                    
                    switch owner.type {
                    case .purchase:
                        owner.showNoTintSingleAlertSheet(actionTitle: "거래 완료", completion: {
                            ProductsManager.shared.completeProducts(id: owner.id)
                                .observe(on: MainScheduler.instance)
                                .subscribe(onSuccess: { _ in
                                    owner.mainView.isComplete = true
                                    NotificationCenter.default.post(
                                        name: .cellIsCompleteUpdate,
                                        object: nil,
                                        userInfo: ["id": owner.id, "isComplete": true]
                                    )
                                }, onFailure: { error in
                                    Log.error(error)
                                })
                                .disposed(by: owner.disposeBag)
                        })
                        
                    case .request:
                        owner.showNoTintSingleAlertSheet(actionTitle: "모집 완료", completion: {
                            ProductsManager.shared.completeProducts(id: owner.id)
                                .observe(on: MainScheduler.instance)
                                .subscribe(onSuccess: { _ in
                                    owner.mainView.isComplete = true
                                    NotificationCenter.default.post(
                                        name: .cellIsCompleteUpdate,
                                        object: nil,
                                        userInfo: ["id": owner.id, "isComplete": true]
                                    )
                                }, onFailure: { error in
                                    Log.error(error)
                                })
                                .disposed(by: owner.disposeBag)
                        })
                        
                    default:
                        break
                    }
                })
            .disposed(by: disposeBag)
        
        mainView.followButton.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _  in
                    if !UserInfoManager.isLoggedIn {
                        owner.needLogIn.accept(true)
                        return
                    }
                    
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    if owner.mainView.isFollowing {
                        UserCommandManager.shared.unfollow(userId: owner.mainView.products?.userID ?? -1)
                            .observe(on: MainScheduler.instance)
                            .subscribe(
                                with: self,
                                onSuccess: { owner, _ in
                                    owner.mainView.isFollowing.toggle()
                                },
                                onFailure: { _, error  in
                                    Log.error(error)
                                })
                            .disposed(by: owner.disposeBag)
                    } else {
                        UserCommandManager.shared.follow(userId: owner.mainView.products?.userID ?? -1)
                            .observe(on: MainScheduler.instance)
                            .subscribe(
                                with: self,
                                onSuccess: { owner, _ in
                                    owner.mainView.isFollowing.toggle()
                                },
                                onFailure: { _, error  in
                                    Log.error(error)
                                })
                            .disposed(by: owner.disposeBag)
                    }
            })
            .disposed(by: disposeBag)

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
        
        viewModel.deletedPost
            .asDriver(onErrorJustReturn: "")
            .drive(
                with: self,
                onNext: { owner, message in
                    
                owner.showSinglePopUpAlert(message: message, actionCompletion: {
                    owner.navigationController?.popViewController(animated: true)
                    owner.viewModel.refresh()
                })
            })
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
