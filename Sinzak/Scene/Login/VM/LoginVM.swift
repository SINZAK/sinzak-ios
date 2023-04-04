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
import RxKakaoSDKAuth
import KakaoSDKUser
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
    }
    
    // MARK: - Output
    
}

private extension DefaultLoginVM {
    
    private func authWithKakao(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            Log.error(error)
        } else {
            
            if let token = oauthToken {
                Task {
                    do {
                        let snsLoginGrant = try await SNSLoginManager.shared.doKakaoLogin(accessToken: token.accessToken).value
                        self.saveUserInKeychain(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                        if snsLoginGrant.joined {
                            Log.debug("홈화면으로")
                        } else {
                            Log.debug("회원가입으로")
                        }
                    } catch {
                        if error is APIError {
                            let apiError = error as! APIError
                            Log.error(apiError.info)
                        }
                    }
                }
                
//                SNSLoginManager.shared.doKakaoLogin(accessToken: token.accessToken)
//                    .subscribe(onSuccess: { grant in
//                        print(grant.accessToken)
//                    })
//                    .disposed(by: disposeBag)
                
            }
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
