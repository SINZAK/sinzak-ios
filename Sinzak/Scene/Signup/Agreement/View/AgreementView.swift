//
//  AgreementView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

import Then
import SnapKit

final class AgreementView: SZView {
    // MARK: - Properties
    let titleLabel = UILabel().then {
        $0.text = "서비스 이용 동의"
        $0.font = .subtitle_B
        $0.textColor = CustomColor.label
    }
    
    // 전체 동의
    let fullCheckButton = CheckButton().then {
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    let fullAgreeLabel = UILabel().then {
        $0.text = "약관 전체동의"
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.isUserInteractionEnabled = true
    }
    
    // 구분선
    private let dividerView = UIView().then {
        $0.backgroundColor = CustomColor.gray60
        $0.layer.cornerRadius = 0.5
    }
    
    // 14세 이상
    let olderFourteenCheckButton = CheckButton().then {
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    let olderFourteenLabel = UILabel().then {
        $0.text = "(필수) 만 14세 이상입니다."
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.isUserInteractionEnabled = true
    }
    
    // 이용약관
    let termsOfServiceCheckButton = CheckButton().then {
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    let termsOfServiceLabel = UILabel().then {
        $0.text = "(필수) 서비스 이용약관"
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.isUserInteractionEnabled = true
    }
    
    let termsOfServiceMoreButton = UIButton().then {
        $0.setImage(UIImage(named: "right-chevron"), for: .normal)
    }
    
    // 개인정보 처리방침
    let privacyPolicyCheckButton = CheckButton().then {
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    let privacyPolicyLabel = UILabel().then {
        $0.text = "(필수) 개인정보 처리방침"
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.isUserInteractionEnabled = true
    }
    
    let privacyPolicyMoreButton = UIButton().then {
        $0.setImage(UIImage(named: "right-chevron"), for: .normal)
    }
    
    // 마케팅 정보
    let marketingInfoCheckButton = CheckButton().then {
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    let marketingInfoLabel = UILabel().then {
        $0.text = "(선택) 마케팅 정보 수신동의"
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.isUserInteractionEnabled = true
    }
    
    let marketingInfoMoreButton = UIButton().then {
        $0.setImage(UIImage(named: "right-chevron"), for: .normal)
    }
    
    // 확인 버튼
    let confirmButton = SZButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.gray20
        $0.layer.cornerRadius = 30
    }
    
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            titleLabel, fullCheckButton, fullAgreeLabel, dividerView,
            olderFourteenCheckButton, olderFourteenLabel,
            termsOfServiceCheckButton, termsOfServiceLabel, termsOfServiceMoreButton,
            privacyPolicyCheckButton, privacyPolicyLabel, privacyPolicyMoreButton,
            marketingInfoCheckButton, marketingInfoLabel, marketingInfoMoreButton,
            confirmButton
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(15.87)
            make.leading.equalToSuperview().inset(32.58)
        }
        fullCheckButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(25.75)
        }
        fullAgreeLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullCheckButton.snp.trailing).offset(5.92)
            make.centerY.equalTo(fullCheckButton)
        }
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.trailing.equalToSuperview().inset(15.58)
            make.top.equalTo(fullCheckButton.snp.bottom).offset(20)
        }
        olderFourteenCheckButton.snp.makeConstraints { make in
            make.width.height.leading.equalTo(fullCheckButton)
            make.top.equalTo(dividerView.snp.bottom).offset(27.14)
        }
        olderFourteenLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullAgreeLabel)
            make.centerY.equalTo(olderFourteenCheckButton)
        }
        termsOfServiceCheckButton.snp.makeConstraints { make in
            make.width.height.leading.equalTo(fullCheckButton)
            make.top.equalTo(olderFourteenCheckButton.snp.bottom).offset(23)
        }
        termsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullAgreeLabel)
            make.centerY.equalTo(termsOfServiceCheckButton)
        }
        termsOfServiceMoreButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalToSuperview().inset(35.32)
            make.centerY.equalTo(termsOfServiceCheckButton)
        }
        privacyPolicyCheckButton.snp.makeConstraints { make in
            make.width.height.leading.equalTo(fullCheckButton)
            make.top.equalTo(termsOfServiceCheckButton.snp.bottom).offset(23)
        }
        privacyPolicyLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullAgreeLabel)
            make.centerY.equalTo(privacyPolicyCheckButton)
        }
        privacyPolicyMoreButton.snp.makeConstraints { make in
            make.width.height.trailing.equalTo(termsOfServiceMoreButton)
            make.centerY.equalTo(privacyPolicyCheckButton)
        }
        marketingInfoCheckButton.snp.makeConstraints { make in
            make.width.height.leading.equalTo(fullCheckButton)
            make.top.equalTo(privacyPolicyCheckButton.snp.bottom).offset(23)
        }
        marketingInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullAgreeLabel)
            make.centerY.equalTo(marketingInfoCheckButton)
        }
        marketingInfoMoreButton.snp.makeConstraints { make in
            make.width.height.trailing.equalTo(termsOfServiceMoreButton)
            make.centerY.equalTo(marketingInfoCheckButton)
        }
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(7.4)
            make.height.equalTo(65)
            make.bottom.equalToSuperview().inset(24.0)
        }
    }
}
