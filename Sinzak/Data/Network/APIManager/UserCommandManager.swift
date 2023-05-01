//
//  UserManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/01.
//

import Foundation
import Moya
import RxSwift

class UserCommandManager {
    private init () {}
    static let shared = UserCommandManager()
    let provider = MoyaProvider<UserCommandAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    let disposeBag = DisposeBag()
    
    func report(userId: Int, reason: String) -> Single<Response> {
        return provider.rx.request(.report(userId: userId, reason: reason))
    }
}
