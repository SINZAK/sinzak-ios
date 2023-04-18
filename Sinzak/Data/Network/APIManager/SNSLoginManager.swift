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
    func doKakaoLogin(accessToken: String) async throws -> SNSLoginGrant {
        var response: Response
        
        do {
            response = try await provider.rx.request(.kakao(accessToken: accessToken)).value
            Log.debug(response.request?.url ?? "")
        } catch {
            throw APIError.unknown(error)
        }
        
        if !(200..<300 ~= response.statusCode) {
            throw APIError.badStatus(code: response.statusCode)
        }
        
        do {
            let snsLoginResultDTO = try JSONDecoder().decode(
                SNSLoginResultDTO.self,
                from: response.data
            )
            
            guard let snsLoginGrantDTO = snsLoginResultDTO.data else {
                throw APIError.noContent
            }
            return snsLoginGrantDTO.toDomain()
            
        } catch {
            throw APIError.decodingError
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
    
    /// naver 로그인
    func doNaverLogin(accessToken: String) -> Single<SNSLoginGrant> {
        return provider.rx.request(.naver(accessToken: accessToken))
            .map { response in
    
                Log.debug(response.request?.url ?? "")
                
                if !(200..<300 ~= response.statusCode) {
                    throw APIError.badStatus(code: response.statusCode)
                }
                
                do {
                    let snsLoginResultDTO = try JSONDecoder().decode(
                        SNSLoginResultDTO.self,
                        from: response.data
                    )
                    
                    guard let snsLoginGrantDTO = snsLoginResultDTO.data else {
                        throw APIError.noContent
                    }
                    return snsLoginGrantDTO.toDomain()
                } catch {
                    throw APIError.decodingError
                }
            }
    }
}
