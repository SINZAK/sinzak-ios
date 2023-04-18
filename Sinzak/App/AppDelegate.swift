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
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        /**  파이어베이스 설정 시작*/
        // 파이어베이스 초기화
        FirebaseApp.configure()
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        // 현재 등록된 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
            }
        }
        /**  파이어베이스 설정 끝 */
        // 카카오로그인
        KakaoSDK.initSDK(appKey: "f4e54dad18c8af8a67dccb0176283616")

        // 네이버로그인
        application.registerForRemoteNotifications()
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true // 네이버앱 로그인 설정
        instance?.isInAppOauthEnable = true // 사파리 로그인 설정

        instance?.serviceUrlScheme = "naverLoginSinzak" // URL Scheme
        instance?.consumerKey = "DwXMEfKZq0tmkrsn6kLk" // 클라이언트 아이디
        instance?.consumerSecret = "LyWqWH9srQ" // 시크릿 아이디
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 네이버 로그인 설정
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        // 카카오 로그인 설정, 13 미만일 때만
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
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
extension AppDelegate: MessagingDelegate {
    // 토큰 갱신 모니터링
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}
