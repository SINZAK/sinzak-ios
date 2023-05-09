//
//  UserQueryManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/08.
//

import Foundation
import Moya
import RxSwift

final class UserQueryManager: ManagerType {
    static let shared = UserQueryManager()
    private init() {}
    
    var provider = MoyaProvider<UserQueryAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    
    /// 프로필 정보 가져와 저장
    func fetchMyProfile() -> Single<UserInfo> {
        return provider.rx.request(.myProfile)
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<UserInfoDTO>.self)
            .map(filterError)
            .map(getData)
            .map { try $0.toDomain() }
            .map {
                UserInfoManager.shared.saveUserInfo(with: $0)
                return $0
            }
            .retry(2)
        
    }
}
