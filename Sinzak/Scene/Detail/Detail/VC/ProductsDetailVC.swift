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
    var type: DetailType
    
    let maxPrice = BehaviorRelay<Int>(value: 0)
    
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
        
        StompManager.shared.disconnect()
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
    // MARK: - Helpers
    override func configure() {
        view.isSkeletonable = true
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
                guard UserInfoManager.isLoggedIn else {
                    owner.needLogIn.accept(true)
                    return
                }
                
                if owner.owner == .mine {
                    owner.showSingleAlertSheet(
                        actionTitle: "삭제하기",
                        completion: {
                            owner.showPopUpAlert(
                                message: "정말 게시글을 삭제할까요?",
                                rightActionTitle: "네, 삭제할게요",
                                rightActionCompletion: {
                                    owner.showLoading()
                                    
                                    var delete: Single<Bool>
                                    
                                    switch owner.type {
                                    case .purchase:
                                        delete = ProductsManager.shared.deleteProducts(id: owner.id)
                                    case .request:
                                        delete = WorksManager.shared.deleteWorks(id: owner.id)
                                    }
                                    
                                    delete
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
                    
//                    owner.showDoubleAlertSheet(
//                        firstActionText: "수정하기",
//                        secondActionText: "삭제하기",
//                        firstCompletion: {
//                            // TODO: 수정 화면으로 이동
//                        },
//                        secondCompletion: {
//
//                            owner.showPopUpAlert(
//                                message: "정말 게시글을 삭제할까요?",
//                                rightActionTitle: "네, 삭제할게요",
//                                rightActionCompletion: {
//                                    owner.showLoading()
//
//                                    var delete: Single<Bool>
//
//                                    switch owner.type {
//                                    case .purchase:
//                                        delete =                                     ProductsManager.shared.deleteProducts(id: owner.id)
//                                    case .request:
//                                        delete = WorksManager.shared.deleteWorks(id: owner.id)
//                                    }
//
//                                    delete
//                                        .observe(on: MainScheduler.instance)
//                                        .subscribe(onSuccess: { _ in
//
//                                            owner.navigationController?.popViewController(animated: true)
//                                            owner.hideLoading()
//                                            owner.viewModel.refresh()
//                                        })
//                                        .disposed(by: owner.disposeBag)
//                                })
//                        }
//                    )
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
                                }, onFailure: { error in
                                    Log.error(error)
                                })
                                .disposed(by: owner.disposeBag)
                        })
                        
                    case .request:
                        owner.showNoTintSingleAlertSheet(actionTitle: "모집 완료", completion: {
                            WorksManager.shared.completeWorks(id: owner.id)                  .observe(on: MainScheduler.instance)
                                .subscribe(onSuccess: { _ in
                                    owner.mainView.isComplete = true
                                }, onFailure: { error in
                                    Log.error(error)
                                })
                                .disposed(by: owner.disposeBag)
                        })
                    }
                })
            .disposed(by: disposeBag)
        
        mainView.followButton.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _  in
                    guard UserInfoManager.isLoggedIn else {
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
        
        mainView.likeButton.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    guard UserInfoManager.isLoggedIn else {
                        owner.needLogIn.accept(true)
                        return
                    }
                    
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    
                    var like: Single<Bool>
                    
                    switch owner.type {
                    case .purchase:
                        like = ProductsManager.shared.likeProducts(
                            id: owner.id,
                            mode: !owner.mainView.isLike
                        )
                    case .request:
                        like = WorksManager.shared.likeWorks(
                            id: owner.id,
                            mode: !owner.mainView.isLike
                        )
                    }

                    like
                        .observe(on: MainScheduler.instance)
                        .subscribe(onSuccess: { _ in
                            owner.mainView.isLike.toggle()
                            
                            let currentCount = Int(owner.mainView.likeButton.titleLabel?.text ?? "-1") ?? -2
                            
                            var newCount: Int
                            if owner.mainView.isLike {
                                newCount = currentCount + 1
                            } else {
                                newCount = currentCount - 1
                            }
                            
                            owner.mainView.likeButton.setTitle("\(newCount)", for: .normal)
                            
                            let name: NSNotification.Name = owner.type == .purchase ? .productsCellLikeUpdate :
                                .worksCellLikeUpdate
                            
                            NotificationCenter.default.post(
                                name: name,
                                object: nil,
                                userInfo: [
                                    "id": owner.mainView.products?.id ?? -1,
                                    "isSelected": owner.mainView.isLike,
                                    "likeCount": newCount
                                ]
                            )
                        })
                        .disposed(by: owner.disposeBag)
                    
                })
            .disposed(by: disposeBag)
        
        mainView.scrapButton.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    guard UserInfoManager.isLoggedIn else {
                        owner.needLogIn.accept(true)
                        return
                    }
                    
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    
                    var wish: Single<Bool>
                    
                    switch owner.type {
                    case .purchase:
                        wish = ProductsManager.shared.wishProducts(
                            id: owner.id,
                            mode: !owner.mainView.isScrap
                        )
                    case .request:
                        wish = WorksManager.shared.wishWorks(
                            id: owner.id,
                            mode: !owner.mainView.isScrap
                        )
                    }

                    wish
                        .observe(on: MainScheduler.instance)
                        .subscribe(onSuccess: { _ in
                            owner.mainView.isScrap.toggle()
                            
                            let currentCount = Int(owner.mainView.scrapCountLabel.text ?? "-1")!
                            
                            if owner.mainView.isScrap {
                                owner.mainView.scrapCountLabel.text = "\(currentCount + 1)"
                            } else {
                                owner.mainView.scrapCountLabel.text = "\(currentCount - 1)"
                            }
                        })
                        .disposed(by: owner.disposeBag)

                })
            .disposed(by: disposeBag)
        
        mainView.askDealButtton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard UserInfoManager.isLoggedIn else {
                    owner.needLogIn.accept(true)
                    return
                }
                
                let id = owner.id
                let type: String = owner.type == .purchase ? "product" : "work"
                
                switch owner.mainView.products?.myPost {
                case true:
                    let vm = DefaultChatListVM()
                    
                    let vc = ChatListVC(viewModel: vm, chatListMode: .request(postID: id, type: type))
                    
                    owner.navigationController?.pushViewController(vc, animated: true)
                case false:
                    owner.viewModel.requestDeal(postID: id, postType: type)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        mainView.priceOfferButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard UserInfoManager.isLoggedIn else {
                    owner.needLogIn.accept(true)
                    return
                }
                
                let vc = SendPriceOfferVC(
                    id: owner.id,
                    maxPrice: owner.maxPrice,
                    type: owner.type
                )
                owner.navigationController?.pushViewController(vc, animated: true)
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
                    owner.maxPrice.accept(data.price)
                    owner.view.hideSkeleton()
                    owner.mainView.skeletonView.isHidden = true
                    
                    if data.author == "탈퇴한 회원" {
                        owner.navigationItem.rightBarButtonItem = nil
                        owner.showSinglePopUpAlert(
                            message: "탈퇴한 회원입니다.",
                            actionCompletion: {
                                owner.navigationController?.popViewController(animated: true)
                        })
                    }
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
        
        viewModel.pushChatRoom
            .asSignal()
            .emit(with: self, onNext: { owner, vc in
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorHandler
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, error in
                owner.simpleErrorHandler.accept(error)
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
