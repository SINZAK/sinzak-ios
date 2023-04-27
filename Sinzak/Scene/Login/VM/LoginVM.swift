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
import NaverThirdPartyLogin
import Alamofire

protocol LoginVMInput {
    func kakaoButtonTapped()
    func naverOauth20ConnectionDidFinishRequestACTokenWithAuthCode()
    func appleAuthorizationControl(token: String)
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
    
    // 네이버로그인 인스턴스
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
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
    
    func naverOauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !accessToken {
            return
        }
        guard let accessToken = naverLoginInstance?.accessToken else {
            return
        }
        
        SNSLoginManager.shared.doNaverLogin(accessToken: accessToken)
            .subscribe(
                with: self,
                onSuccess: { owner, snsLoginGrant in
                    UserInfoManager.snsKind = SNS.naver.rawValue
                    Log.debug("Access Token: \(snsLoginGrant.accessToken)")
                    Log.debug("Refresh Token: \(snsLoginGrant.refreshToken)")
                    if snsLoginGrant.joined {
                        owner.goTabBar(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                    } else {
                        owner.goSignUp(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                    }
                }, onFailure: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
    }
    
    func appleAuthorizationControl(token: String) {
        SNSLoginManager.shared.doAppleLogin(idToken: token)
            .subscribe(
                with: self,
                onSuccess: { owner, snsLoginGrant in
                    UserInfoManager.snsKind = SNS.apple.rawValue
                    Log.debug("Access Token: \(snsLoginGrant.accessToken)")
                    Log.debug("Refresh Token: \(snsLoginGrant.refreshToken)")
                    SNSLoginManager.shared.getAppleClientSecret()
                    if snsLoginGrant.joined {
                        owner.goTabBar(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                    } else {
                        owner.goSignUp(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                    }
                }, onFailure: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
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
                    UserInfoManager.snsKind = SNS.kakao.rawValue
                    let snsLoginGrant = try await SNSLoginManager.shared.doKakaoLogin(accessToken: token)
                    
                    Log.debug("Access Token: \(snsLoginGrant.accessToken)")
                    Log.debug("Refresh Token: \(snsLoginGrant.refreshToken)")
                    if snsLoginGrant.joined {
                        goTabBar(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                    } else {
                        goSignUp(
                            accessToken: snsLoginGrant.accessToken,
                            refreshToken: snsLoginGrant.refreshToken
                        )
                    }
                } catch {
                    throw error
                }
            }
        }
    }
    
    func goTabBar(accessToken: String, refreshToken: String) {
        KeychainItem.saveTokenInKeychain(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        AuthManager.shared.fetchMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    let vc = TabBarVC()
                    owner.changeRootTabBar.accept(vc)
                },
                onFailure: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
    }
    
    func goSignUp(accessToken: String, refreshToken: String) {
        self.onboardingUser.accesToken = accessToken
        self.onboardingUser.refreshToken = refreshToken
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
