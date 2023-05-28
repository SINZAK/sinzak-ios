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
import SwiftKeychainWrapper

final class LoginVC: SZVC {
    // MARK: - Properties
    let mainView = LoginView()
    var viewModel: LoginVM!
    
    // 네이버로그인 인스턴스
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naverLoginInstance?.delegate = self
        
        cleanUserInfo()
    }
    
    init(viewModel: LoginVM!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureNeedLoginLayout() {
        mainView.configureNeedLoginLayout()
        
        configureDismissButton()
    }
    
    func configureDismissButton() {
        let dismissBarButton = UIBarButtonItem(
            image: UIImage(named: "dismiss")?.withTintColor(
                CustomColor.label,
                renderingMode: .alwaysOriginal
            ),
            style: .plain,
            target: self,
            action: #selector(dismissTapped)
        )
        
        navigationItem.leftBarButtonItem = dismissBarButton
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
        
        viewModel.showLoading
            .bind(with: self, onNext: { owner, isShow in
                
                if isShow == true {
                    owner.showLoading()
                } else {
                    owner.hideLoading()
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.errorHandler
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, error in
                if error is APIError {
                    let apiError = error as! APIError
                    
                    switch apiError {
                    case .errorMessage(let message):
                        owner.showSinglePopUpAlert(message: message)
                    case .badStatus(code: _):
                        owner.showSinglePopUpAlert(message: "알 수 없는 오류가 발생했습니다.")
                    default:
                        Log.error(error)
                    }
                } else {
                    Log.error(error)
                }
                
                self.hideLoading()
                
                UserApi.shared.logout {(error) in
                    if let error = error {
                        Log.error(error)
                    } else {
                        Log.debug("Kakao logout() success.")
                    }
                }
                
                owner.naverLoginInstance?.resetToken()
                
                AppleAuth
                    .allCases
                    .map { $0.rawValue }
                    .forEach { KeychainWrapper.standard.removeObject(forKey: $0)}
                
                Log.error(error)
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
            let code = String(
                decoding: appleIDCredential.authorizationCode ?? Data(),
                as: UTF8.self
            )
            Log.debug(code)
            KeychainWrapper.standard.set(code, forKey: AppleAuth.appleAuthCode.rawValue)
            
        default:
            break
        }
    }
    /// Apple ID 연동 실패 시
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Log.error(error)
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

private extension LoginVC {
    
    /// 유저 정보 남아있는 경우 대비해서 비워주기
    func cleanUserInfo() {
        
        UserApi.shared.logout {(error) in
            if let error = error {
                Log.error(error)
            } else {
                Log.debug("Kakao logout() success.")
            }
        }
        
        naverLoginInstance?.resetToken()
        
        AppleAuth
            .allCases
            .map { $0.rawValue }
            .forEach { KeychainWrapper.standard.removeObject(forKey: $0)}
        
        UserInfoManager.shared.logout(completion: {})
    }
    
    @objc
    func dismissTapped() {
        dismiss(animated: true)
    }
}
