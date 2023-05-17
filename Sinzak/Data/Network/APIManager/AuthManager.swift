//
//  AuthManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/08.
//

import Foundation
import Moya
import RxSwift
import UIKit

final class AuthManager: ManagerType {
    // MARK: - Properties
    private init () {}
    static let shared = AuthManager()
    let provider = MoyaProvider<AuthAPI>(
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
 
    
    /// 학교 메일 인증
    func certifyUnivMail(univName: String, univEmail: String) -> Single<Bool> {
        return provider.rx.request(.univMailCertify(
            univName: univName,
            univEmail: univEmail
        ))
        .filterSuccessfulStatusCodes()
        .map(BaseDTO<String>.self)
        .map(filterError)
        .map { $0.success }
    }
    
    /// 학교 메일 인증코드 인증
    func certifyUnivMailCode(code: Int, univName: String, univEmail: String) -> Single<Bool> {
        return provider.rx.request(.univMailCodeCertify(
            code: code,
            univName: univName,
            univEmail: univEmail
        ))
        .filterSuccessfulStatusCodes()
        .map(BaseDTO<String>.self)
        .map(filterError)
        .map { $0.success }
    }
    
    func certifySchoolCard1(univ: String) -> Single<Int> {
        return provider.rx.request(.univSchoolCardCertify1(univ: univ))
            .filterSuccessfulStatusCodes()
            .map(CertifySchoolCardDTO.self)
            .map { result -> Int in
                if result.success == false {
                    throw APIError.errorMessage(result.message ?? "")
                }
            
                return result.id ?? -1
            }
    }
    
    func certifySchoolCard2(id: Int, image: UIImage) -> Single<Bool> {
        return provider.rx.request(.univSchoolCardCertify2(id: id, image: image))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<String>.self)
            .map(filterError)
            .map { $0.success }
    }
}
