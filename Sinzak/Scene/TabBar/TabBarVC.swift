//
//  TabBarVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/10.
//

import UIKit
import RxSwift
import RxCocoa

final class TabBarVC: UITabBarController {
    
    // MARK: - Property
    
    // 홈화면 & 마켓화면에서 공유
    let selectedCategory: BehaviorRelay<[ProductsCategory]> = .init(value: [])
    let selectedAlign: BehaviorRelay<AlignOption> = .init(value: .recommend)
    let isSaling: BehaviorRelay<Bool> = .init(value: false)
    let needRefresh: BehaviorRelay<Bool> = .init(value: true)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTabBarController()
    }
    /// 탭바 색상 지정
    private func setUI() {
        tabBar.tintColor = CustomColor.red
        tabBar.unselectedItemTintColor = CustomColor.label
        tabBar.backgroundColor = CustomColor.background
    }
    /// 탭 바 구성
    private func setTabBarController() {
        
        self.delegate = self
        
        // 홈
        let homeVM = DefaultHomeVM(
            selectedCategory,
            selectedAlign,
            isSaling,
            needRefresh
        )
        
        let homeVC = UINavigationController(rootViewController: HomeVC(viewModel: homeVM))
        
        homeVC.tabBarItem = UITabBarItem(title: "홈",
                                         image: UIImage(named: "home"),
                                         selectedImage: UIImage(named: "home-selected"))
        // 마켓
        let marketVM = DefaultMarketVM(
            selectedCategory,
            selectedAlign,
            isSaling,
            needRefresh
        )
        let marketVC = UINavigationController(rootViewController: MarketVC(viewModel: marketVM, mode: .watch))
        marketVC.tabBarItem = UITabBarItem(title: "마켓",
                                         image: UIImage(named: "market"),
                                         selectedImage: UIImage(named: "market-selected"))
        // 의뢰
        let worksVC = UINavigationController(rootViewController: WorksContainerVC(worksMode: .watch))
        worksVC.tabBarItem = UITabBarItem(title: "외주",
                                         image: UIImage(named: "outsourcing"),
                                         selectedImage: UIImage(named: "outsourcing-selected"))
        
        // 채팅
        let vm = DefaultChatListVM()
        let chatVC = UINavigationController(rootViewController: ChatListVC(viewModel: vm, chatListMode: .all))
        chatVC.tabBarItem = UITabBarItem(title: "채팅",
                                         image: UIImage(named: "chat"),
                                         selectedImage: UIImage(named: "chat-selected"))
        // 프로필
        let profileVC = UINavigationController(rootViewController: ProfileVC(
            // TODO: 복구 필요 mine 으로
            profileType: .mine,
            viewModel: DefaultProfileVM(),
            needSettingBarButton: true
        ))
        profileVC.tabBarItem = UITabBarItem(title: "프로필",
                                            image: UIImage(named: "profile"),
                                            selectedImage: UIImage(named: "profile-selected"))
        // 탭 구성
        setViewControllers([homeVC, marketVC, worksVC, chatVC, profileVC], animated: true)
    }
}

extension TabBarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard !UserInfoManager.isLoggedIn, let nav = viewController as? UINavigationController else { return true }
        
        if nav.viewControllers[0] is ChatListVC || nav.viewControllers[0] is ProfileVC {
            let loginVC: LoginVC = {
                let vc = LoginVC(viewModel: DefaultLoginVM())
                vc.configureNeedLoginLayout()
                
                return vc
            }()
            
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            return false
        }
        
        return true
    }
}
