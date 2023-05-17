//
//  SignoutCompleteVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/18.
//

import UIKit
import RxSwift
import RxCocoa

final class SignoutCompleteVC: SZVC {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private let signoutCompleteLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.red
        label.font = .signoutTitle
        label.text = "탈퇴가 완료되었습니다."
        label.textAlignment = .center
        
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
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

private extension SignoutCompleteVC {
    
    func bind() {
        
        confirmButton.rx.tap
            .bind(onNext: { _ in
                    let vc = TabBarVC()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: true)
                })
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Layout
private extension SignoutCompleteVC {
    func configureLayout() {
        view.addSubviews(
            signoutCompleteLabel,
            confirmButton
        )
        
        signoutCompleteLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(156.0)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(24.0)
            $0.height.equalTo(64.0)
        }
    }
}
