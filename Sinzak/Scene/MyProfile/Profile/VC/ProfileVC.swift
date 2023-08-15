//
//  ProfileVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/12.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

enum ProfileType {
    case mine
    case others(userID: Int)
}

final class ProfileVC: SZVC {
    // MARK: - Properties
    let profileType: ProfileType
    let viewModel: ProfileVM
    let mainView: ProfileView
    let disposeBag = DisposeBag()
    var needSettingBarButton: Bool
    var userInfo: UserInfo?
    
    init(
        profileType: ProfileType,
        viewModel: ProfileVM,
        needSettingBarButton: Bool
    ) {
        self.profileType = profileType
        self.mainView = ProfileView(profileType: profileType)
        self.viewModel = viewModel
        self.needSettingBarButton = needSettingBarButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.profileSkeletonView.isHidden = false
        view.showAnimatedSkeleton()
        
        if case let .others(userID) = profileType {
            viewModel.fetchOthersProfile(userID: userID)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
            
        if case .mine = profileType {
            viewModel.fetchMyProfile()
        }
    }
    // MARK: - Helpers
    override func configure() {
        view.isSkeletonable = true
        
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        
        if needSettingBarButton {
            let setting = UIBarButtonItem(image: UIImage(named: "setting"),
                                          style: .plain,
                                          target: nil,
                                          action: nil)
            navigationItem.rightBarButtonItem = setting
        }
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        mainView.scrollView.refreshControl?.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.mainView.scrollView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.dismiss(animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    let vc = SettingVC()
                    owner
                        .navigationController?
                        .pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.profileEditButton.rx.tap
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    guard let profile = owner.userInfo?.profile else { return }
                    let vm = DefaultEditProfileVM()
                    let vc = EditProfileVC(profile: profile, viewModel: vm)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    
                    owner.present(nav, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        mainView.followButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    guard case .others = owner.profileType else { return }
                    
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    let isFollowing = owner.mainView.followButton.isFollowing
                    owner.viewModel.followButtonTapped(isFollowing: isFollowing)
                }
            )
            .disposed(by: disposeBag)
        
        let tapScrapListView = UITapGestureRecognizer()
        mainView.scrapListView.addGestureRecognizer(tapScrapListView)
        tapScrapListView.rx.event
            .bind(with: self, onNext: { owner, _ in
                let vm = DefaultScrapListVM()
                let vc = ScrapListVC(viewModel: vm)
                owner.navigationController?.pushViewController(
                    vc,
                    animated: true
                )
            })
            .disposed(by: disposeBag)
        
        let tapRequestView = UITapGestureRecognizer()
        mainView.requestListView.addGestureRecognizer(tapRequestView)
        tapRequestView.rx.event
            .bind(with: self, onNext: { owner, _ in
                let vc = MyPostListVC(
                    type: .request,
                    products: owner.userInfo?.workEmploys ?? [],
                    postListType: .request
                )
                owner.navigationController?.pushViewController(
                    vc,
                    animated: true
                )
            })
            .disposed(by: disposeBag)
        
        let tapSalesView = UITapGestureRecognizer()
        mainView.salesListView.addGestureRecognizer(tapSalesView)
        tapSalesView.rx.event
            .bind(with: self, onNext: { owner, _ in
                let vc = MyPostListVC(
                    type: .purchase,
                    products: owner.userInfo?.products ?? [],
                    postListType: .products
                )
                owner.navigationController?.pushViewController(
                    vc,
                    animated: true
                )
            })
            .disposed(by: disposeBag)
        
        let tapWorkView = UITapGestureRecognizer()
        mainView.workListView.addGestureRecognizer(tapWorkView)
        tapWorkView.rx.event
            .bind(with: self, onNext: { owner, _ in
                let vc = MyPostListVC(
                    type: .request,
                    products: owner.userInfo?.works ?? [],
                    postListType: .works
                )
                owner.navigationController?.pushViewController(
                    vc,
                    animated: true
                )
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
        viewModel.userInfoRelay
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(
                with: self,
                onNext: { owner, userInfo in
                    
                    owner.mainView.configureProfile(with: userInfo.profile)
                    owner.userInfo = userInfo
                    
                    if owner.view.sk.isSkeletonActive {
                        owner.view.hideSkeleton()
                        owner.mainView.profileSkeletonView.isHidden = true
                    }
                })
            .disposed(by: disposeBag)
        
        viewModel.isFollowRelay.asSignal()
            .emit(to: mainView.followButton.rx.isFollowing)
            .disposed(by: disposeBag)
        
        viewModel.followingCountRelay.asDriver()
            .drive(mainView.followerNumberLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
