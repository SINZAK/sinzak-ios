//
//  LoginVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/26.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser
import NaverThirdPartyLogin
import Alamofire

final class LoginVC: SZVC {
    // MARK: - Properties
    let mainView = LoginView()
    // 네이버로그인 인스턴스
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        naverLoginInstance?.delegate = self
    }
    // MARK: - Actions
    /// 카카오 버튼 눌렀을 때
    @objc func kakaoButtonTapped(_ sender: UIButton) {
        // 로그인 / 회원가입 분기
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")

                    // do something
                    if let token = oauthToken {
                        SNSLoginManager.shared.doKakaoLogin(accessToken: token.accessToken) { [weak self] result in
                            switch result {
                            case let .success(data):
                                if data.data.joined {
                                    // 가입했을 경우 홈으로 보내주고 액세스토큰, 리프레시 토큰은 키체인에 저장
                                    self?.goHome()
                                } else {
                                    // 가입 안했을 경우 회원가입으로 보내기
                                    self?.goSignup()
                                }
                            case let .failure(error): print(error)
                            }
                        }
                    } else {
                        print("login info doesn't come correctly")
                    }
                }
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
        naverLoginInstance?.requestThirdPartyLogin()
        
       // goSignup()
    }
    /// 로그인이 안될 경우 / 이메일 중복이 아닐 경우
    func goSignup() {
        let rootVC = AgreementVC()
        let vc = UINavigationController(rootViewController: rootVC)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: false)
    }
    /// 이미 가입한 유저일 경우 홈화면으로 이동
    func goHome() {
        let vc = TabBarVC()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: false)
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
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken
            if let idToken = idToken {
                let strToken = String(decoding: idToken, as: UTF8.self)
                SNSLoginManager.shared.doAppleLogin(idToken: "\(strToken)") { [weak self] result in
                    switch result {
                    case let .success(data):
                        if data.data.joined {
                            // 가입했을 경우 홈으로 보내주고 액세스토큰, 리프레시 토큰은 키체인에 저장
                            self?.goHome()
                            // 키체인에 저장
                            self?.saveUserInKeychain(data.data.accessToken)
                        } else {
                            // 가입 안했을 경우 회원가입으로 보내기
                            self?.goSignup()
                        }
                    case let .failure(error): print(error)
                    }
                }
            }
            // print("User Email : \(email ?? "")")
            // print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
        default:
            break
        }
    }
    /// Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    /// 로그인 정보를 키체인에 저장
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.kimdee.Sinzak", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("키체인에 userIdentifier 저장 불가")
        }
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
// 네이버로그인 관련
extension LoginVC: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        self.naverLoginPaser()
    }
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰\(naverLoginInstance?.accessToken)")
        if let loginInstance = naverLoginInstance {
            SNSLoginManager.shared.doNaverLogin(accessToken: loginInstance.accessToken) { [weak self] result in
                switch result {
                case let .success(data):
                    print("🤖🤖🤖", data)
                    if data.data.joined {
                        // 가입했을 경우 홈으로 보내주고 액세스토큰, 리프레시 토큰은 키체인에 저장
                        self?.goHome()
                    } else {
                        // 가입 안했을 경우 회원가입으로 보내기
                        self?.goSignup()
                    }
                case let .failure(error): print(error)
                }
            }
        } else {
            print("Naver Login Information doesn't delivered correctly.")
        }
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("에러 = \(error.localizedDescription)")
    }
    func naverLoginPaser() {
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !accessToken {
            return
        }
        
        guard let tokenType = naverLoginInstance?.tokenType else {
            return
            
        }
        guard let accessToken = naverLoginInstance?.accessToken else {
            return
        }
        
        print("NAVER Access Token", accessToken)
        
        
        let requestUrl = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: requestUrl)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            
            guard let body = response.value as? [String: Any] else { return }
            
            if let resultCode = body["message"] as? String{
                if resultCode.trimmingCharacters(in: .whitespaces) == "success"{
                    let resultJson = body["response"] as! [String: Any]
                    let name = resultJson["name"] as? String ?? ""
                    let id = resultJson["id"] as? String ?? ""
                    let phone = resultJson["mobile"] as? String ?? ""
                    let gender = resultJson["gender"] as? String ?? ""
                    let birthyear = resultJson["birthyear"] as? String ?? ""
                    let birthday = resultJson["birthday"] as? String ?? ""
                    let profile = resultJson["profile_image"] as? String ?? ""
                    let email = resultJson["email"] as? String ?? ""
                    let nickName = resultJson["nickname"] as? String ?? ""
                    print("네이버 로그인 이름 ", name)
                    print("네이버 로그인 아이디 ", id)
                    print("네이버 로그인 핸드폰 ", phone)
                    print("네이버 로그인 성별 ", gender)
                    print("네이버 로그인 생년 ", birthyear)
                    print("네이버 로그인 생일 ", birthday)
                    print("네이버 로그인 프로필사진 ", profile)
                    print("네이버 로그인 이메일 ", email)
                    print("네이버 로그인 닉네임 ", nickName)
                }
                else {
                    // 실패
                }
            }
        }
    }
}
