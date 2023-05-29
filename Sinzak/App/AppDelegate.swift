//
//  AppDelegate.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/11/19.
//

import UIKit
import KakaoSDKCommon
import NaverThirdPartyLogin
import FirebaseCore
import FirebaseMessaging
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 원격 알림 시스템에 앱을 등록
        let authOptions: UNAuthorizationOptions = [
            .alert,
            .badge,
            .sound
        ]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, error in
                if let error = error {
                    Log.error(error)
                }
        })
        
        application.registerForRemoteNotifications()
        
        // 파이어베이스 초기화
        FirebaseApp.configure()
        
        // 카카오로그인
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        // 네이버로그인
        application.registerForRemoteNotifications()
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true // 네이버앱 로그인 설정
        instance?.isInAppOauthEnable = true // 사파리 로그인 설정
        
        let naverURLScheme = Bundle.main.infoDictionary?["NAVER_URL_SCHEME"] as? String ?? ""
        let naverClientID = Bundle.main.infoDictionary?["NAVER_CLIENT_ID"] as? String ?? ""
        let naverSecretID = Bundle.main.infoDictionary?["NAVER_SECRET_ID"] as? String ?? ""
        
        instance?.serviceUrlScheme = naverURLScheme // URL Scheme
        instance?.consumerKey = naverClientID // 클라이언트 아이디
        instance?.consumerSecret = naverSecretID // 시크릿 아이디
        instance?.appName = "신작" // 앱이름
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// 네이버, 카카오로그인 SDK 설정
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // 네이버 로그인 설정
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        // 카카오 로그인 설정, 13 미만일 때만
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return true
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    // 포그라운드 상태에서도 알림: 로컬/푸시 동일
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // .banner, .list: iOS 14+부터 사용가능
        completionHandler([.badge, .sound, .banner, .list])
    }
}
