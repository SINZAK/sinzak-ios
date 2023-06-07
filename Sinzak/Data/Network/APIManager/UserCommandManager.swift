//
//  UserManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/01.
//

import UIKit
import Moya
import RxSwift
import FirebaseMessaging

class UserCommandManager: ManagerType {
    private init () {}
    static let shared = UserCommandManager()
    let provider = MoyaProvider<UserCommandAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    let disposeBag = DisposeBag()
    
    func report(userId: Int, reason: String) -> Single<Bool> {
        return provider.rx.request(.report(userId: userId, reason: reason))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func follow(userId: Int) -> Single<Bool> {
        return provider.rx.request(.follow(userId: userId))
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func unfollow(userId: Int) -> Single<Bool> {
        return provider.rx.request(.unfollow(userId: userId))
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func editCategoryLike(genreLikes: [AllGenre]) -> Single<Bool> {
        let genreLikes: String = genreLikes
            .map { $0.rawValue }
            .joined(separator: ",")
        
        return provider.rx.request(.editGenre(genres: genreLikes))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func editUserImage(image: UIImage, isIcon: Bool) -> Single<Bool> {
        return provider.rx.request(.editUserImage(image: image, isIcon: isIcon))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<EditUserImageDTO>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func editUserInfo(name: String, introduction: String) -> Single<Bool> {
        let userInfoEdit = UserInfoEdit(
            name: name,
            introduction: introduction
        )
        return provider.rx.request(.editUserInfo(userInfo: userInfoEdit))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
    
    func getFCMToken() -> Single<Bool> {
        return Observable<Bool>.create { observer in
            Messaging.messaging().token { [weak self] token, error in
                guard let self = self else { return }
                
                guard error == nil else {
                    Log.error(error.debugDescription)
                    observer.onError(APIError.unknown(nil))
                    return
                }
                Log.debug("FCM Token: \(token ?? "")")
                self.saveFCM(
                    userID: UserInfoManager.userID ?? -1,
                    token: token ?? ""
                )
                observer.onNext(true)
            }
                return Disposables.create()
        }
        .asSingle()
    }
    
    func saveFCM(userID: Int, token: String) {
        provider.rx.request(.saveFCM(
            userID: userID,
            fcmToken: token
        ))
        .filterSuccessfulStatusCodes()
        .map(BaseDTO<String>.self)
        .map(filterError)
        .subscribe(
            onSuccess: { _ in
                Log.debug("Save FCM token success.")
            },
            onFailure: { error in
                Log.error("Save FCM token fail. \(error)")
            })
        .disposed(by: disposeBag)
    }
}
