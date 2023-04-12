//
//  UniversityInfoView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import SnapKit
import Then

final class UniversityInfoView: SZView {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = I18NStrings.pleaseSelectUniversity
        $0.font = .subtitle_B
        $0.textColor = CustomColor.label
    }
    let searchTextField = SZTextField(insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).then {
        $0.backgroundColor = CustomColor.gray10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
        $0.font = .caption_B
        $0.textColor = CustomColor.label
        $0.placeholder = I18NStrings.searchBySchoolName
        $0.clearButtonMode = .whileEditing
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.backgroundColor = CustomColor.gray10
        $0.isHidden = true // 검색결과가 있을 경우 false 처리 후 보여주기
    }
    let buttonStack = UIStackView().then {
        $0.spacing = 12
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let notStudentButton = UIButton().then {
        $0.setTitle(I18NStrings.notStudent, for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.gray60
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    let nextButton = UIButton().then {
        $0.setTitle(I18NStrings.next, for: .normal)
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.red
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 33
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            titleLabel, searchTextField,
            collectionView,
            buttonStack
        )
        buttonStack.addArrangedSubviews(
            notStudentButton, nextButton
        )
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.equalToSuperview().inset(33)
            make.trailing.lessThanOrEqualToSuperview().inset(33)
        }
        searchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(38)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(searchTextField)
            make.top.equalTo(searchTextField.snp.bottom).offset(12)
            make.height.equalTo(128)
        }
        buttonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24.0)
            make.height.equalTo(65)
        }
    }
}
