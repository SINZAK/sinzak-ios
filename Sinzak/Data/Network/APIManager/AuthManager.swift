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
    
    func checkNickname(for nickNmae: String) async throws -> Bool {
        do {
            let response = try await provider.rx.request(.nicknameCheck(nickname: nickNmae)).value
            Log.debug(response.request?.url ?? "")
            
            if !(200..<300 ~= response.statusCode) {
                throw APIError.badStatus(code: response.statusCode)
            }
            
            do {
                guard let checkInfo = try JSONSerialization
                    .jsonObject(with: response.data) as? [String: Any] else {
                    throw APIError.decodingError
                }
                let success: Int = checkInfo["success"] as? Int ?? -1
                
                return success == 1 ? true : false
            } catch {
                throw APIError.decodingError
            }
            
        } catch {
            throw APIError.unknown(error)
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
