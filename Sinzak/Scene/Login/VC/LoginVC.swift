//
//  LoginVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/26.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser

final class LoginVC: SZVC {
    // MARK: - Properties
    let mainView = LoginView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Actions
    /// 카카오 버튼 눌렀을 때
    @objc func kakaoButtonTapped(_ sender: UIButton) {
        // 로그인 / 회원가입 분기
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                _ = oauthToken
                // 이메일로 로그인 / 중복가입여부 체크
                //self?.setKakaoUserInfo()
                self?.goSignup()
            }
        }
    }
    /// 애플 버튼 눌렀을 때
    @objc func appleButtontapped(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email,]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    /// 네이버 버튼 눌렀을 때
    @objc func naverButtonTapped(_ sender: UIButton) {
        goSignup()
    }
    /// 로그인이 안될 경우 / 이메일 중복이 아닐 경우
    func goSignup() {
        let vc = AgreementVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.kakaoButton.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        mainView.appleButton.addTarget(self, action: #selector(appleButtontapped), for: .touchUpInside)
        mainView.naverButton.addTarget(self, action: #selector(naverButtonTapped), for: .touchUpInside)
    }
}
// 애플 로그인 관련 메서드
extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    /// 애플 로그인을 모달시트로 띄워줌
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    /// Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            if let email = email {
                AuthManager.shared.checkEmail(email)
            }
        default:
            break
        }
    }
    
    /// Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
// 카카오로그인 관련 메서드
extension LoginVC {
    func setKakaoUserInfo() {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("me() success")
                var scopes = [String]()
                if (user?.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
                
                if scopes.count > 0 {
                    UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            UserApi.shared.me() { (user, error) in
                                if let error = error {
                                    print(error)
                                }
                                else {
                                    print("me() success.")
                                    
                                    //do something
                                    _ = user
                                    if let email = user?.kakaoAccount?.email {
                                        // 로그인
                                        
                                        // 로그인 안될 경우, 이메일 중복여부
                                        AuthManager.shared.checkEmail(email)
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    print("사용자의 추가 동의가 필요하지 않습니다.")
                }
            }
        }
    }
}
