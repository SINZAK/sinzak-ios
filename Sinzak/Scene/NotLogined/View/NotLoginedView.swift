//
//  NotLoginedView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/12.
//

import UIKit

import Then
import SnapKit

final class NotLoginedView: SZView {
    // MARK: - Properties
    private let loginLabel = UILabel().then {
        $0.font = .title_B
        $0.textAlignment = .center
        $0.textColor = CustomColor.black
        $0.numberOfLines = 0
        $0.text = I18NStrings.youCanUseAfterLogin
    }
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
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(loginLabel, startLabel, stackView)
        stackView.addArrangedSubviews(kakaoButton, naverButton, appleButton)
    }
    override func setLayout() {
        loginLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(stackView.snp.top)
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
        startLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).offset(-17.8)
        }
    }
}

