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
                    Log.debug(snsLoginGrant.accessToken)
                    Log.debug(snsLoginGrant.refreshToken)
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
        
        //        guard let tokenType = naverLoginInstance?.tokenType else {
        //            return
        //        }
//        print("NAVER Access Token", accessToken)
//
//        let requestUrl = "https://openapi.naver.com/v1/nid/me"
//        let url = URL(string: requestUrl)!
//        let authorization = "\(tokenType) \(accessToken)"
//        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
//        req.responseData { response in
//
//            guard let body = try? JSONSerialization.jsonObject(with: response.value ?? Data()) as? [String: Any] else {
//                Log.error("네이버 data decoding 에러")
//                return
//            }
//            if let resultCode = body["message"] as? String {
//                if resultCode.trimmingCharacters(in: .whitespaces) == "success" {
//                    let resultJson = body["response"] as! [String: Any]
//                    let id = resultJson["id"] as? String ?? ""
//                    let email = resultJson["email"] as? String ?? ""
//                    print("네이버 로그인 아이디 ", id)
//                    print("네이버 로그인 이메일 ", email)
//                } else {
//                    Log.error("네이버 정보 가져오기 싪")
//                }
//            }
//        }
    }
    
    func appleAuthorizationControl(token: String) {
        SNSLoginManager.shared.doAppleLogin(idToken: token)
            .subscribe(
                with: self,
                onSuccess: { owner, snsLoginGrant in
                    Log.debug(snsLoginGrant.accessToken)
                    Log.debug(snsLoginGrant.refreshToken)
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
                    let snsLoginGrant = try await SNSLoginManager.shared.doKakaoLogin(accessToken: token)
                    
                    Log.debug(snsLoginGrant.accessToken)
                    Log.debug(snsLoginGrant.refreshToken)
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
        DispatchQueue.main.async { [weak self] in
            let vc = TabBarVC()
            self?.changeRootTabBar.accept(vc)
        }
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
