//
//  SignoutCheckVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/18.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKUser
import RxSwift
import RxCocoa

final class SignoutCheckVC: SZVC {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private let signoutCheckLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.red
        label.font = .signoutTitle
        label.text = "정말로\n탈퇴하시겠습니까?"
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private let signoutInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray80
        label.font = .signoutSubtitle
        label.text = "탈퇴 시 더 이상 해당 계정에 접근할 수 없어요."
        label.textAlignment = .center
        
        return label
    }()
    
    private let signoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.titleLabel?.font = .body_B
        button.titleLabel?.textColor = CustomColor.white
        button.backgroundColor = CustomColor.gray60
        button.layer.cornerRadius = 64.0 / 2
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .body_B
        button.titleLabel?.textColor = CustomColor.white
        button.backgroundColor = CustomColor.red
        button.layer.cornerRadius = 64.0 / 2
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure
    
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "탈퇴하기"
    }
    
    override func configure() {
        tabBarController?.tabBar.isHidden = true
        configureLayout()
        bind()
    }
}

private extension SignoutCheckVC {
    
    func bind() {
        
        signoutButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.showLoading()
                    let snsKind = UserInfoManager.snsKind ?? ""
                    switch snsKind {
                    case SNS.kakao.text:
                        UserApi.shared.unlink { error in
                            if let error = error {
                                Log.error(error)
                            } else {
                                Log.debug("Kakao unlink() success.")
                            }
                        }
                        
                    case SNS.naver.text:
                        NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
                        
                    case SNS.apple.text:
                        AppleAuthManager.shared.revokeAppleToken()
                        
                    default:
                        Log.error("SNS 회원 탈퇴 오류")
                    }
                
                    AuthManager.shared.resign()
                        .observe(on: MainScheduler.instance)
                        .subscribe(
                            with: self,
                            onSuccess: { owner, _ in
                                Log.debug("회원 탈퇴 성공")
                                
                                UserInfoManager.shared.logout(completion: {
                                    
                                    let vc = SignoutCompleteVC()
                                    owner.navigationController?.pushViewController(
                                        vc,
                                        animated: true
                                    )
                                    owner.hideLoading()
                                })
                                
                            }, onFailure: { owner, error in
                                owner.simpleErrorHandler.accept(error)
                            })
                        .disposed(by: owner.disposeBag)
                    
                    
                })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                })
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Layout
private extension SignoutCheckVC {
    func configureLayout() {
        view.addSubviews(
            signoutCheckLabel,
            signoutInfoLabel,
            signoutButton,
            cancelButton
        )
        
        signoutCheckLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(148.0)
            $0.centerX.equalToSuperview()
        }
        
        signoutInfoLabel.snp.makeConstraints {
            $0.top.equalTo(signoutCheckLabel.snp.bottom).offset(16.0)
            $0.centerX.equalToSuperview()
        }
        
        let width = (UIScreen.main.bounds.width - 16.0 - 12.0 - 16.0) / 2
        signoutButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(24.0)
            $0.height.equalTo(64.0)
            $0.width.equalTo(width)
        }
        
        cancelButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(24.0)
            $0.height.equalTo(64.0)
            $0.width.equalTo(width)
        }
    }
}
