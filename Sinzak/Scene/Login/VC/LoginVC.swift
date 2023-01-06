//
//  LoginVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/26.
//

import UIKit
import AuthenticationServices

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
    @objc
    func kakaoButtonTapped(_ sender: UIButton) {
        // 로그인 / 회원가입 분기
        let vc = AgreementVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func appleButtontapped(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    // 애플 로그인을 모달시트로 띄워줌
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // MARK: - Helpers
    override func configure() {
        mainView.kakaoButton.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        mainView.appleButton.addTarget(self, action: #selector(appleButtontapped), for: .touchUpInside)
    }
}

extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    // Apple ID 연동 성공 시
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

        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
