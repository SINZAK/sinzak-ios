//
//  LoginVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/04.
//

import Foundation
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKUser

protocol LoginVMInput {
    func kakaoButtonTapped()
}

protocol LoginVMOutput {
    
}

protocol LoginVM: LoginVMInput, LoginVMOutput {}

final class DefaultLoginVM: LoginVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func kakaoButtonTapped() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                guard let self = self else { return }
                self.authWithKakao(oauthToken: oauthToken, error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                guard let self = self else { return }
                self.authWithKakao(oauthToken: oauthToken, error: error)
            }
        }
        
//        if UserApi.isKakaoTalkLoginAvailable() {
//            UserApi.shared.rx.loginWithKakaoTalk()
//                .subscribe(onNext: { [weak self] _ in
//                    Log.debug("Login With KakaoTalk success.")
//                }, onError: { error in
//                    Log.error("login With KakaoTalk error: \(error)")
//                })
//                .disposed(by: disposeBag)
//        } else {
//            UserApi.shared.rx.loginWithKakaoAccount()
//                .subscribe(onNext: { [weak self] _ in
//                    Log.debug("Login With KakaoAccount sucess.")
//                }, onError: { error in
//                    Log.error("login With KakaoAccount error: \(error)")
//                })
//                .disposed(by: disposeBag)
//        }
        
    }
    
    // MARK: - Output
    
}

private extension DefaultLoginVM {
    
    private func authWithKakao(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            Log.error(error)
        } else {
            
            if let token = oauthToken?.accessToken {
                Task {
                    do {
                        Log.debug("인디게이터 시작")
                        let snsLoginGrant = try await SNSLoginManager.shared.doKakaoLogin(accessToken: token)
                        saveUserInKeychain(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                        Log.debug("Thread: \(Thread.current)")
                        if snsLoginGrant.joined {
                            Log.debug("홈화면으로")
                        } else {
                            Log.debug("회원가입으로")
                        }
                        Log.debug("인디게이터 끝")
                    } catch {
                        if error is APIError {
                            let apiError = error as! APIError
                            Log.error(apiError.info)
                        } else {
                            Log.error(error)
                        }                    }
                }
            }
                
//                SNSLoginManager.shared.doKakaoLogin(accessToken: token.accessToken)
//                    .subscribe(onSuccess: { [weak self] snsLoginGrant in
//                        Log.debug("Thread: \(Thread.current)")
//                        guard let self = self else { return }
//                        self.saveUserInKeychain(
//                            accessToken: snsLoginGrant.accessToken,
//                            refreshToken: snsLoginGrant.refreshToken
//                        )
//                        Log.debug("Thread: \(Thread.current)")
//                        if snsLoginGrant.joined {
//                            Log.debug("홈화면으로")
//                        } else {
//                            Log.debug("회원가입으로")
//                        }
//                    }, onFailure: { error in
//                        if error is APIError {
//                            let apiError = error as! APIError
//                            Log.error(apiError.info)
//                        } else {
//                            Log.error(error)
//                        }
//                    })
//                    .disposed(by: disposeBag)
//            }
        }
    }

    /** 토큰  정보를 키체인에 저장 */
    private func saveUserInKeychain(accessToken: String, refreshToken: String) {
            do {
                try KeychainItem(account: TokenKind.accessToken.text).saveItem(accessToken)
            } catch {
                print("키체인에 액세스 토큰 정보 저장 불가")
            }
            do {
                try KeychainItem(account: TokenKind.refreshToken.text).saveItem(refreshToken)
            } catch {
                print("키체인에 리프레시 토큰 정보 저장 불가")
            }
    }
}
