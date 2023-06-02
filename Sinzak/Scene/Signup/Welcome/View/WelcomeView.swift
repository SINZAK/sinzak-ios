//
//  WelcomeView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import UIKit
import SnapKit
import Then
import SwiftConfettiView

final class WelcomeView: SZView {
    // MARK: - Properties
    let confettiView = SwiftConfettiView(frame: UIScreen.main.bounds).then {
        $0.type = .diamond
        $0.intensity = 0.7
    }
    private let welcomeLabel = UILabel().then {
        $0.font = .title_B
        $0.textColor = CustomColor.red
        $0.text = "Welcome!"
    }
    private let welcomeDescriptionLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.gray80
        $0.text = "신작에 가입이 완료되었습니다.\n이제 자유롭게 작품을 탐색하고 거래해보세요."
        $0.textAlignment = .center
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "welcome-image")
    }
    let letsGoButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
        $0.backgroundColor = CustomColor.red
        $0.setTitle("작품 보러 가기", for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            confettiView,
            welcomeLabel,
            welcomeDescriptionLabel,
            imageView,
            letsGoButton
        )
    }
    override func setLayout() {
        confettiView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
        }
        welcomeDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(6)
        }
        letsGoButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(65)
            make.bottom.equalToSuperview().inset(24.0)
        }
        imageView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(letsGoButton.snp.top).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.centerY.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.19)
        }
    }
}
