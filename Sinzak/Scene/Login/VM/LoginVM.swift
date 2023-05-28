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
    
    var showLoading: PublishRelay<Bool> { get }
    var errorHandler: PublishRelay<Error> { get }
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
                .subscribe(
                    with: self,
                    onNext: { owner, oauthToken in
                        do {
                            try owner.authWithKakao(oauthToken: oauthToken)
                        } catch {
                            owner.errorHandler.accept(error)
                        }
                    },
                    onError: { owner, error in
                        owner.errorHandler.accept(error)
                    })
                .disposed(by: disposeBag)
    
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(
                    with: self,
                    onNext: { owner, oauthToken in
                        do {
                            try owner.authWithKakao(oauthToken: oauthToken)
                        } catch {
                            owner.errorHandler.accept(error)
                        }
                    },
                    onError: { owner, error in
                        owner.errorHandler.accept(error)
                    })
                .disposed(by: disposeBag)
        }
    }
    
    func naverOauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        showLoading.accept(true)
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
                    owner.showLoading.accept(false)
                    UserInfoManager.snsKind = SNS.naver.text
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
                }, onFailure: { owner, error in
                    owner.errorHandler.accept(error)
                    owner.showLoading.accept(false)
                })
            .disposed(by: disposeBag)
    }
    
    func appleAuthorizationControl(token: String) {
        showLoading.accept(true)
        SNSLoginManager.shared.doAppleLogin(idToken: token)
            .subscribe(
                with: self,
                onSuccess: { owner, snsLoginGrant in
                    owner.showLoading.accept(false)
                    UserInfoManager.snsKind = SNS.apple.text
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
                }, onFailure: { owner, error in
                    owner.showLoading.accept(false)
                    owner.errorHandler.accept(error)
                })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    var changeRootTabBar: PublishRelay<TabBarVC> = .init()
    var pushSignUp: PublishRelay<AgreementVC> = .init()
    var showLoading: PublishRelay<Bool> = .init()
    var errorHandler: PublishRelay<Error> = .init()
}
    
private extension DefaultLoginVM {

    func authWithKakao(oauthToken: OAuthToken?) throws {
        showLoading.accept(true)
        if let token = oauthToken?.accessToken {
            Task {
                do {
                    UserInfoManager.snsKind = SNS.kakao.text
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
                        showLoading.accept(false)
                    }
                } catch {
                    self.errorHandler.accept(error)
                    showLoading.accept(true)
                    throw error
                }
            }
        }
        showLoading.accept(false)
    }
    
    func goTabBar(accessToken: String, refreshToken: String) {
        KeychainItem.saveTokenInKeychain(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        UserQueryManager.shared.fetchMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    let vc = TabBarVC()
                    owner.changeRootTabBar.accept(vc)
                },
                onFailure: { owner, error in
                    owner.errorHandler.accept(error)
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
}
