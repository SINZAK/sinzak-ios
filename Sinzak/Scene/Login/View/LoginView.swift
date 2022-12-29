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
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.logoText
    }
    private let startLabel = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.gray80
        $0.text = I18NStrings.startWithSnsLogin
    }
    private let stackView = UIStackView().then {
        $0.spacing = 16
    }
    private let kakaoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "kakao_logo")
    }
    private let naverImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "naver_logo")
    }
    private let appleImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "apple_logo")
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(logotypeImage, logoLabel, startLabel, stackView)
        stackView.addArangedSubviews(kakaoImage, naverImage, appleImage)
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
        kakaoImage.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(kakaoImage.snp.height)
        }
        naverImage.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(naverImage.snp.height)
        }
        appleImage.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(appleImage.snp.height)
        }
        startLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).offset(-17.8)
        }
    }
}
