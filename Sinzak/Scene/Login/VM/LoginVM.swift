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
    var onboardingUser: OnboardingUser { get set }
}

protocol LoginVMOutput {
    var changeRootTabBar: PublishRelay<TabBarVC> { get }
    var pushSignUp: PublishRelay<AgreementVC> { get }
}

protocol LoginVM: LoginVMInput, LoginVMOutput {}

final class DefaultLoginVM: LoginVM {
    
    private let disposeBag = DisposeBag()
    
    var onboardingUser: OnboardingUser = OnboardingUser()
    
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

                    Log.debug(snsLoginGrant.accessToken)
                    Log.debug(snsLoginGrant.refreshToken)
                    if snsLoginGrant.joined {
                        KeychainItem.saveTokenInKeychain(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                        goTabBar()
                    } else {
                        self.onboardingUser.accesToken = snsLoginGrant.accessToken
                        self.onboardingUser.refreshToken = snsLoginGrant.accessToken
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
            guard let self = self else { return }
            let vm = DefaultAgreementVM(onboardingUser: self.onboardingUser)
            let vc = AgreementVC(viewModel: vm)
            self.pushSignUp.accept(vc)
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
