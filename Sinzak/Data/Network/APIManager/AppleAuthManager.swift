//
//  AppleAuthManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/23.
//

import Foundation
import Moya
import RxSwift
import SwiftKeychainWrapper

class AppleAuthManager {
    private init () {}
    static let shared = AppleAuthManager()
    let provider = MoyaProvider<AppleAuthAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    let disposeBag = DisposeBag()
    
    func getAppleRefreshToken(authCode: String) {
        provider.rx.request(.refreshToken(authCode: authCode))
            .filterSuccessfulStatusCodes()
            .map(AppleToken.self)
            .retry(2)
            .subscribe(
                onSuccess: { token in
                    KeychainWrapper.standard.set(token.refreshToken ?? "", forKey: AppleAuth.refresh.rawValue)
                }, onFailure: { error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
    }
    
    func revokeAppleToken() {
        provider.rx.request(.revoke)
            .filterSuccessfulStatusCodes()
            .retry(2)
            .subscribe(
                onSuccess: { _ in
                    // 애플 관련된거 삭제
                    KeychainWrapper.standard.removeObject(forKey: AppleAuth.refresh.rawValue)
                    
                    AppleAuth
                        .allCases
                        .map { $0.rawValue }
                        .forEach { KeychainWrapper.standard.removeObject(forKey: $0)}
                    
                }, onFailure: { error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
    }
}
