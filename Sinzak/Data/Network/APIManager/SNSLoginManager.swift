//
//  SNSLoginManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/05.
//

import Foundation
import Moya

class SNSLoginManager {
    private init () {}
    static let shared = SNSLoginManager()
    let provider = MoyaProvider<SNSLoginAPI>()
    /// 애플로그인
    func doAppleLogin(idToken: String, origin: String = "apple", completion: @escaping ((Result<SNSLoginResult, Error>) -> Void) ) {
        provider.request(.apple(idToken: idToken, origin: origin)) { (result) in
            // escaping completion handler로 처리하기
            switch result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SNSLoginResult.self, from: data.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    /// kakao 로그인
    func doKakaoLogin(accessToken: String, origin: String = "kakao", completion: @escaping ((Result<SNSLoginResult, Error>) -> Void) ) {
        provider.request(.kakao(accessToken: accessToken, origin: origin)) { (result) in
            // escaping completion handler로 처리하기
            switch result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SNSLoginResult.self, from: data.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    /// naver 로그인
    func doNaverLogin(accessToken: String, origin: String = "naver", completion: @escaping ((Result<SNSLoginResult, Error>) -> Void) ) {
        provider.request(.naver(accessToken: accessToken, origin: origin)) { (result) in
            // escaping completion handler로 처리하기
            switch result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SNSLoginResult.self, from: data.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
