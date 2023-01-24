//
//  NotificationVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import Tabman
import Pageboy

final class NotificationVC: TabmanViewController {
    // MARK: - Properties
    // 페이징할 VC
    var viewControllers: Array<UIViewController> = [ActivityNotiVC(), FollowNotiVC()]
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바 숨김처리
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Helpers
    func configure() {
        view.backgroundColor = CustomColor.white
        // 탭바 Datasource
        self.dataSource = self
        // 탭바 생성
        let bar = TMBar.ButtonBar()
        settingTabBar(for: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    /// 네비게이션 바 설정
    func setNavigationBar() {
        // 색상 설정
        navigationController?.navigationBar.tintColor = CustomColor.black
        // 루트뷰가 아닐 경우 백버튼
        if self != navigationController?.viewControllers.first {
            let customBackButton = UIBarButtonItem(
                image: UIImage(named: "back"),
                style: .plain,
                target: self,
                action: #selector(backButtonTapped) )
            navigationItem.leftBarButtonItem = customBackButton
        }
        navigationItem.title = "알림"
    }
    // MARK: - Actions
    /// 네비게이션  뒤로가기 버튼
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
// 탭바 관련 설정
extension NotificationVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // Tab Title
        switch index {
        case 0:
            return TMBarItem(title: " 활동 " )
        case 1:
            return TMBarItem(title: "팔로우")
        default:
            return TMBarItem(title: "")
        }
    }
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        // 페이지 갯수
        return 2
    }
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
extension NotificationVC {
    func settingTabBar (for bar: TMBar.ButtonBar) {
        bar.layout.transitionStyle = .progressive
        bar.layout.alignment = .centerDistributed
        // 간격
        bar.layout.interButtonSpacing = 35
        bar.backgroundView.style = .blur(style: .light)
        // 바버튼 색상, 폰트
        bar.buttons.customize { (button) in
            button.tintColor = CustomColor.gray60
            button.selectedTintColor = CustomColor.black
            button.font = .body_B
            button.selectedFont = .body_B
        }
        // 인디케이터 설정
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = CustomColor.black
    }
}
