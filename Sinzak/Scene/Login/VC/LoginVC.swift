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
import RxSwift

final class LoginVC: SZVC {
    // MARK: - Properties
    let mainView = LoginView()
    var viewModel: LoginVM!
    
    // 네이버로그인 인스턴스
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naverLoginInstance?.delegate = self
        
        naverLoginInstance?.requestDeleteToken()
        
        UserApi.shared.logout {(error) in
            if let error = error {
                Log.error(error)
            } else {
                Log.debug("Kakao logout() success.")
            }
        }
        
    }
    
    init(viewModel: LoginVM!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        bind()
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    // MARK: - Bind Input
    func bindInput() {
        
        mainView.kakaoButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.kakaoButtonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.naverButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.naverLoginInstance?.requestThirdPartyLogin()
            })
            .disposed(by: disposeBag)
        
        mainView.appleButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = owner
                authorizationController.presentationContextProvider = owner
                authorizationController.performRequests()
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Bind Output
    func bindOutput() {
        viewModel.changeRootTabBar
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { vc in
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushSignUp
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
/** 애플 로그인 관련 메서드 */
extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    /// 애플 로그인을 모달시트로 띄워줌
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    /// Apple ID 연동 성공 시
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // 계정 정보 가져오기
            let idToken = appleIDCredential.identityToken
            if let idToken = idToken {
                let strToken = String(decoding: idToken, as: UTF8.self)
                viewModel.appleAuthorizationControl(token: strToken)
            }
            
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
            // print("User Email : \(email ?? "")")
            // print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
        default:
            break
        }
    }
    /// Apple ID 연동 실패 시
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        // Handle error.
        showAlert(title: "ERROR\nApple ID 연동에 실패했습니다.", okText: I18NStrings.confirm, cancelNeeded: false, completionHandler: nil)
    }
}

/** 네이버로그인 관련  메서드*/
extension LoginVC: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        Log.debug("네이버 로그인 성공!")
        self.viewModel.naverOauth20ConnectionDidFinishRequestACTokenWithAuthCode()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {}
    
    func oauth20ConnectionDidFinishDeleteToken() {
        Log.debug("네이버 로그아웃!")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        Log.error("에러 = \(error.localizedDescription)")
    }
}
