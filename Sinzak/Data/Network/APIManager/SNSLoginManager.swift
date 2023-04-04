//
//  SNSLoginManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/05.
//

import Foundation
import Moya
import RxSwift

class SNSLoginManager {
    private init () {}
    static let shared = SNSLoginManager()
    let provider = MoyaProvider<SNSLoginAPI>()
    let disposeBag = DisposeBag()
    /// 애플로그인
    func doAppleLogin(idToken: String, origin: String = "apple", completion: @escaping ((Result<SNSLoginResult, Error>) -> Void) ) {
        provider.request(.apple(idToken: idToken)) { (result) in
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
        provider.request(.kakao(accessToken: accessToken)) { (result) in
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
    
    func doKakaoLogin(accessToken: String) -> Single<SNSLoginGrant> {
        return Single<SNSLoginGrant>.create { [weak self] single in
            guard let self = self else { return Disposables.create {} }
            self.provider.rx.request(.kakao(accessToken: accessToken))
                .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
                .subscribe { event in
                    switch event {
                    case let .success(response):
                        Log.debug(response.request?.url ?? "No URL")
                        
                        guard 200..<300 ~= response.statusCode else {
                            single(.failure(APIError.badStatus(code: response.statusCode)))
                            return
                        }
                        do {
                            guard let snsLoginGrantDTO = try JSONDecoder().decode(
                                SNSLoginResultDTO.self,
                                from: response.data
                            ).data else {
                                single(.failure(APIError.noContent))
                                return
                            }
                            let snsLoginGrant = snsLoginGrantDTO.toDomain()
                            Log.debug(snsLoginGrant)
                            single(.success(snsLoginGrant))
                        } catch {
                            single(.failure(APIError.decodingError))
                        }
                    case let .failure(error):
                        single(.failure(APIError.unknown(error)))
                    }
                }
                .disposed(by: self.disposeBag)
            return Disposables.create {}
        }
    }
    
    /// naver 로그인
    func doNaverLogin(accessToken: String, origin: String = "naver", completion: @escaping ((Result<SNSLoginResult, Error>) -> Void) ) {
        provider.request(.naver(accessToken: accessToken)) { (result) in
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
