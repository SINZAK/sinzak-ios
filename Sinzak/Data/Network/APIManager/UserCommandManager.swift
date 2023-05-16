//
//  UserManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/01.
//

import Foundation
import Moya
import RxSwift

class UserCommandManager: ManagerType {
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
    
    func updateCategoryLike(genreLikes: [AllGenre]) -> Single<Bool> {
        let genreLikes: String = genreLikes
            .map { $0.rawValue }
            .joined(separator: ",")
        
        return provider.rx.request(.updateGenre(genres: genreLikes))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
}
