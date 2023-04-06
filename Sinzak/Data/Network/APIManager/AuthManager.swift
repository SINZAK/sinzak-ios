//
//  AuthManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/08.
//

import Foundation
import Moya

class AuthManager {
    // MARK: - Properties
    private init () {}
    static let shared = AuthManager()
    let provider = MoyaProvider<AuthAPI>()
    // MARK: - Methods
    /// 닉네임 중복 확인
    func checkNickname(for nickname: String, completion: @escaping ((Bool) -> Void)) {
        provider.request(.nicknameCheck(nickname: nickname)) { result in
            switch result {
            case let .success(data):
                do { let decoder = JSONDecoder()
                    let result = try decoder.decode(OnlySuccess.self, from: data.data)
                    completion(result.success)
                } catch {
                    completion(false)
                }
            case let .failure(error):
                print("Nickname check error", error)
                completion(false)
            }
        }
    }
    /// 회원가입
    func join(_ joinInfo: Join, completion: @escaping ((Bool) -> Void)) {
        provider.request(.join(joinInfo: joinInfo)) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(true)
//                do {
//                    let result = try response.map(OnlySuccess.self)
//                    completion(result.success)
//                } catch {
//                    print("Error decoding JSON: \(error.localizedDescription)")
//                    completion(false)
//                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    /// 회원정보 추가, 편집
    /// - 자기소개, 이름, 사진
    func editUserInfo(_ userInfo: UserInfo, completion: @escaping ((Bool) -> Void)) {
        provider.request(.editUserInfo(userInfo: userInfo)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try response.map(OnlySuccess.self)
                    completion(result.success)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    /// 관심장르 편집
    func editCategory(_ category: CategoryLikeEdit, completion: @escaping ((Bool)-> Void)) {
        provider.request(.editCategoryLike(category: category)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try response.map(OnlySuccess.self)
                    completion(result.success)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    /// FCM 토큰 업데이트
    func updateFCMToken(_ token: FCMTokenUpdate, completion: @escaping ((Bool)-> Void)) {
        provider.request(.fcmTokenUpdate(fcmInfo: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try response.map(OnlySuccess.self)
                    completion(result.success)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
