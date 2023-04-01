//
//  TabBarVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/10.
//

import UIKit

final class TabBarVC: UITabBarController {
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
        // 홈
        let homeVC = UINavigationController(rootViewController: HomeVC())
        homeVC.tabBarItem = UITabBarItem(title: I18NStrings.Home,
                                         image: UIImage(named: "home"),
                                         selectedImage: UIImage(named: "home-selected"))
        // 마켓
        let marketVM = DefaultMarketVM()
        let marketVC = UINavigationController(rootViewController: MarketVC(viewModel: marketVM))
        marketVC.tabBarItem = UITabBarItem(title: I18NStrings.Market,
                                         image: UIImage(named: "market"),
                                         selectedImage: UIImage(named: "market-selected"))
        // 의뢰
        let worksVC = UINavigationController(rootViewController: WorksVC())
        worksVC.tabBarItem = UITabBarItem(title: I18NStrings.Outsourcing,
                                         image: UIImage(named: "outsourcing"),
                                         selectedImage: UIImage(named: "outsourcing-selected"))
        // 채팅
        let chatVC = UINavigationController(rootViewController: ChatListVC())
        chatVC.tabBarItem = UITabBarItem(title: I18NStrings.Chat,
                                         image: UIImage(named: "chat"),
                                         selectedImage: UIImage(named: "chat-selected"))
        // 프로필
        let profileVC = UINavigationController(rootViewController: MyProfileVC())
        profileVC.tabBarItem = UITabBarItem(title: I18NStrings.Profile,
                                         image: UIImage(named: "profile"),
                                         selectedImage: UIImage(named: "profile-selected"))
        // 탭 구성
        setViewControllers([homeVC, marketVC, worksVC, chatVC, profileVC], animated: true)
    }
}
