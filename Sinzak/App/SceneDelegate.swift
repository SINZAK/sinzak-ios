//
//  SceneDelegate.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/11/19.
//

import UIKit
import KakaoSDKAuth
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 루트 뷰 변경
        let vc = ConciergeVC()
        let nav = UINavigationController(rootViewController: vc)
        
        changeRootVC(nav, animated: true)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}
extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // 카카오 SDK 설정
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            } else {
                // 네이버 SDK 설정
                NaverThirdPartyLoginConnection
                    .getSharedInstance()?
                    .receiveAccessToken(URLContexts.first?.url)                
            }
        }
    }
}
// 루트뷰 설정하는 메서드 선언
extension SceneDelegate {
    func changeRootVC(_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc // 전환
        UIView.transition(with: window, duration: 0.26, options: [.transitionCrossDissolve], animations: nil, completion: nil)
      }
}
