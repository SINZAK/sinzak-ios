//
//  AuthManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/08.
//

import Moya

class AuthManager {
    private init () {}
    static let shared = AuthManager()
    let provider = MoyaProvider<AuthAPI>()
    /// 이메일 중복 확인
    func checkEmail(_ email: String) {
        provider.request(.checkemail(email: email)) { (result) in
            // escaping completion handler로 처리하기 
            switch result {
            case let .success(response):
                if response.response?.statusCode == 200 {
                    print("가입할 수 있는 이메일")
                } else {
                    print("가입할 수 없는 이메일")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    /// 회원가입
    func join(_ userInfo: JoinUser) {
        provider.request(.signup(userInfo: userInfo)) { (result) in
            switch result {
            case let .success(response):
                if response.response?.statusCode == 200 {
                    print("가입완료")
                } else {
                    print("가입불가")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

