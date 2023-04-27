//
//  AuthManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/08.
//

import Foundation
import Moya
import RxSwift

class AuthManager {
    // MARK: - Properties
    private init () {}
    static let shared = AuthManager()
    private let provider = MoyaProvider<AuthAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    let disposeBag = DisposeBag()
    // MARK: - Methods
    
    /// 닉네임 중복 확인
    func checkNickname(for nickNmae: String) async throws -> Bool {
        do {
            let response = try await provider.rx.request(.nicknameCheck(nickname: nickNmae)).value
            
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
    func join(_ joinInfo: Join) -> Single<Bool> {
        return provider.rx.request(.join(joinInfo: joinInfo))
            .map({ response in
                
                if !(200..<300 ~= response.statusCode) {
                    throw APIError.badStatus(code: response.statusCode)
                }
                
                let result: ResultMessageDTO
                do {
                    result = try JSONDecoder().decode(ResultMessageDTO.self, from: response.data)
                } catch {
                    throw APIError.decodingError
                }
                
                if let message = result.message {
                    throw APIError.errorMessage(message)
                }
                return result.success ?? false
            })
            .retry(2)
    }
    
    /// 회원 탈퇴
    func resign() -> Single<Void> {
        return provider.rx.request(.resign)
            .map({ response in
                
                if !(200..<300 ~= response.statusCode) {
                    throw APIError.badStatus(code: response.statusCode)
                }
                
                let result: ResultMessageDTO
                do {
                    result = try JSONDecoder().decode(ResultMessageDTO.self, from: response.data)
                } catch {
                    throw APIError.decodingError
                }
                
                if let message = result.message {
                    throw APIError.errorMessage(message)
                }
            })
            .retry(2)
    }
    
    /// reissue 토큰 재발급(Concierge View에서 로그인용으로 사용)
    func reissue() -> Single<Reissue> {
        return provider.rx.request(.reissue)
            .filterSuccessfulStatusCodes()
            .map(ReissueDTO.self)
            .map { reissueDTO in
                if let success = reissueDTO.success, !success {
                    throw APIError.errorMessage(reissueDTO.message ?? "")
                }
                return reissueDTO.toDomain()
            }
            .do(onSuccess: { reissue in
                KeychainItem.saveTokenInKeychain(
                    accessToken: reissue.accessToken,
                    refreshToken: reissue.refreshToken
                )
            })
            .retry(2)
    }
    
    /// reissue 토큰 재발급(plug in 에서 만료시 사용)
    func reissueForPlugin() {
        let provider = MoyaProvider<AuthAPI>(callbackQueue: .global())
        provider.rx.request(.reissue)
            .filterSuccessfulStatusCodes()
            .map(ReissueDTO.self)
            .map { reissueDTO in
                if let success = reissueDTO.success, !success {
                    throw APIError.errorMessage(reissueDTO.message ?? "")
                }
                return reissueDTO.toDomain()
            }
            .retry(2)
            .subscribe(
                onSuccess: { reissue in
                    Log.debug("Success Reissue: \(reissue)")
                    KeychainItem.saveTokenInKeychain(
                        accessToken: reissue.accessToken,
                        refreshToken: reissue.refreshToken
                    )
                }, onFailure: { error in
                    Log.error("Fail Reissue: \(error)")
                })
            .disposed(by: disposeBag)
    }
    
    /// 프로필 정보 가져와 저장
    func fetchMyProfile() -> Single<Bool> {
        return provider.rx.request(.myProfile)
            .filterSuccessfulStatusCodes()
            .map(UserInfoResponseDTO.self)
            .map({ responseDTO in
                do {
                    guard let response = try responseDTO.data?.toDomain() else { throw APIError.noContent }
                    UserInfoManager.shared.saveUserInfo(with: response)
                    return true
                } catch {
                    throw APIError.noContent
                }
            })
            .retry(2)
    }
    
    /// 회원정보 추가, 편집
    /// - 자기소개, 이름, 사진
    func editUserInfo(_ userInfo: UserInfoEdit, completion: @escaping ((Bool) -> Void)) {
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
        provider.request(.fcmTokenUpdate(fcmInfo: token), callbackQueue: .global()) { result in
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
