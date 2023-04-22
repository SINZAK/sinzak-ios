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
        plugins: [MoyaLoggerPlugin()]
    )
    let disposeBag = DisposeBag()
    // MARK: - Methods
    
    /// 닉네임 중복 확인
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
    func join(_ joinInfo: Join) -> Single<Bool> {
        return provider.rx.request(.join(joinInfo: joinInfo))
            .map({ response in
                
                Log.debug(response.request?.url ?? "")
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
    }
    
    /// 회원 탈퇴
    func resign() -> Single<Void> {
        return provider.rx.request(.resign)
            .map({ response in
                
                Log.debug(response.request?.url ?? "")
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
    }
    
    /// reissue 토큰 재발급
    func reissue() -> Single<Reissue> {
        return provider.rx.request(.reissue)
            .filterSuccessfulStatusCodes()
            .map(ReissueDTO.self)
            .map { $0.toDomain() }
            .do(onSuccess: { reissue in
                Log.debug(reissue)
                KeychainItem.saveTokenInKeychain(
                    accessToken: reissue.accessToken,
                    refreshToken: reissue.refreshToken
                )
            })
            .retry(2)
    }
    
    /// 프로필 정보 가져와 저장
    func fetchMyProfile() {
            provider.rx.request(.myProfile)
            .filterSuccessfulStatusCodes()
            .map(UserInfoResponseDTO.self)
            .subscribe(onSuccess: { responseDTO in
                do {
                    guard let response = try responseDTO.data?.toDomain() else { throw APIError.noContent }
                    UserInfoManager.shared.saveUserInfo(with: response)
                } catch {
                    Log.error(error)
                }
            }, onFailure: { error in
                Log.error(error)
            })
            .disposed(by: disposeBag)
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
