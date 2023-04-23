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
    
    func getAppleRefreshToken(accessToken: String) {
        provider.rx.request(.refreshToken(accessToken: accessToken))
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
                onSuccess: { response in
                    let _ = response
                    // 애플 관련된거 삭제
                }, onFailure: { error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
    }
}
