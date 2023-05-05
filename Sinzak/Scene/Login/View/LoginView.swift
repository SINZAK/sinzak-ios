//
//  LoginView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/26.
//

import UIKit

import Then
import SnapKit

final class LoginView: SZView {
    // MARK: - Properties
    private let logotypeImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "logotype")
    }
    private let logoLabel = UILabel().then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.label
        $0.text = I18NStrings.logoText
    }
    
    private let needLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 후에\n만나볼 수 있어요"
        label.textColor = CustomColor.label
        label.font = .title_B
        label.isHidden = true
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private let startLabel = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.gray80
        $0.text = I18NStrings.startWithSnsLogin
    }
    private let stackView = UIStackView().then {
        $0.spacing = 16
    }
    let kakaoButton = UIButton().then {
        $0.setImage(UIImage(named: "kakao_logo"), for: .normal)
    }
    let naverButton = UIButton().then {
        $0.setImage(UIImage(named: "naver_logo"), for: .normal)
    }
    let appleButton = UIButton().then {
        $0.setImage(UIImage(named: "apple_logo"), for: .normal)
    }
    
    func configureNeedLoginLayout() {
        logotypeImage.isHidden = true
        logoLabel.isHidden = true
        needLoginLabel.isHidden = false
    }
    
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(logotypeImage, logoLabel, startLabel, stackView, needLoginLabel)
        stackView.addArrangedSubviews(kakaoButton, naverButton, appleButton)
    }
    override func setLayout() {
        logotypeImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(35)
            make.top.equalTo(safeAreaLayoutGuide).inset(70)
            make.width.equalTo(160)
            make.height.equalTo(53)
        }
        logoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(44)
            make.top.equalTo(logotypeImage.snp.bottom).offset(4)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(146)
            make.height.equalTo(56)
        }
        kakaoButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(kakaoButton.snp.height)
        }
        naverButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(naverButton.snp.height)
        }
        appleButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(appleButton.snp.height)
        }
        
        needLoginLabel.snp.makeConstraints {
            $0.bottom.equalTo(startLabel.snp.top).offset(-188.0)
            $0.centerX.equalToSuperview()
        }
        
        startLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).offset(-17.8)
        }
    }
}
