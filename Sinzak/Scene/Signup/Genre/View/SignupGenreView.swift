//
//  SignupGenreView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

import Then
import SnapKit

final class SignupGenreView: SZView {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = I18NStrings.pleaseSelectGenreOfInterest
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
        $0.numberOfLines = 0
    }
    private let descriptionLabel = UILabel().then {
        $0.text = I18NStrings.upToThreeCanBeSelected
        $0.font = .body_R
        $0.textColor = CustomColor.gray60
        $0.numberOfLines = 0
    }
    // 관심장르 목록 콜렉션 뷰
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .clear
        $0.bounces = false
    }
    // 다음 버튼
    let nextButton = SZButton().then {
        $0.setTitle(I18NStrings.next, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.red
        $0.layer.cornerRadius = 30
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            titleLabel, descriptionLabel, collectionView, nextButton
        )
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16.0)
            make.leading.equalToSuperview().inset(32.0)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8.21)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(37)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(18)
            make.bottom.equalTo(nextButton.snp.top).offset(18)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(7.4)
            make.height.equalTo(65)
            make.bottom.equalToSuperview().inset(24.0)
        }
    }
}
