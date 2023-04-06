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
    var changeRootTabBar: PublishRelay<TabBarVC> { get }
    var pushSignUp: PublishRelay<AgreementVC> { get }
}

protocol LoginVM: LoginVMInput, LoginVMOutput {}

final class DefaultLoginVM: LoginVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func kakaoButtonTapped() {
        if UserApi.isKakaoTalkLoginAvailable() {
       
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext: { [weak self] oauthToken in
                    do {
                        try self?.authWithKakao(oauthToken: oauthToken)
                    } catch {
                        self?.handleError(error)
                    }
                }, onError: { [weak self] error in
                    self?.handleError(error)
                })
                .disposed(by: disposeBag)
    
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { [weak self] oauthToken in
                    do {
                        try self?.authWithKakao(oauthToken: oauthToken)
                    } catch {
                        self?.handleError(error)
                    }
                }, onError: { [weak self] error in
                    self?.handleError(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Output
    var changeRootTabBar: PublishRelay<TabBarVC> = .init()
    var pushSignUp: PublishRelay<AgreementVC> = .init()
}
    
private extension DefaultLoginVM {

    func authWithKakao(oauthToken: OAuthToken?) throws {
        if let token = oauthToken?.accessToken {
            Task {
                do {
                    let snsLoginGrant = try await SNSLoginManager.shared.doKakaoLogin(accessToken: token)
                    saveUserInKeychain(
                        accessToken: snsLoginGrant.accessToken,
                        refreshToken: snsLoginGrant.refreshToken
                    )
                    if snsLoginGrant.joined {
                        goTabBar()
                    } else {
                        goSignUp()
                    }
                } catch {
                    throw error
                }
            }
        }
    }
    
    func goTabBar() {
        DispatchQueue.main.async { [weak self] in
            let vc = TabBarVC()
            self?.changeRootTabBar.accept(vc)
        }
    }
    
    func goSignUp() {
        DispatchQueue.main.async { [weak self] in
            let vm = DefaultAgreementVM()
            let vc = AgreementVC(viewModel: vm)
            self?.pushSignUp.accept(vc)
        }
    }
    
    /** 토큰  정보를 키체인에 저장 */
    func saveUserInKeychain(accessToken: String, refreshToken: String) {
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
    
    func handleError(_ error: Error ) {
        if error is APIError {
            let apiError = error as! APIError
            Log.error(apiError.info)
        } else {
            Log.debug(error)
        }
    }
    
}
