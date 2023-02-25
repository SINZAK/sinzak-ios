//
//  RequestContentView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/25.
//

import UIKit
import SnapKit
import Then

final class RequestContentView: SZView {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.gray80
        $0.text = " · " + I18NStrings.artworkTitle
    }
    let titleTextField = SZTextField().then {
        $0.backgroundColor = CustomColor.gray10
        $0.layer.cornerRadius = 30
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.clearButtonMode = .whileEditing
    }
    private let requestContentLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.gray80
        $0.text = " · " + I18NStrings.requestContent
    }
    let requestContentTextView = UITextView().then {
        $0.text = I18NStrings.requestContentPlaceholder
        $0.backgroundColor = CustomColor.gray10
        $0.contentInset = .init(top: 20, left: 35, bottom: 20, right: 22)
        $0.layer.cornerRadius = 30
        $0.tintColor = CustomColor.red
        $0.font = .body_R
        $0.textColor = CustomColor.black
    }
    let nextButton = UIButton().then {
        $0.setTitle(I18NStrings.next, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.layer.cornerRadius = 33
        $0.backgroundColor = CustomColor.red
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            titleLabel,
            titleTextField,
            requestContentLabel,
            requestContentTextView,
            nextButton
        )
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        requestContentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleTextField.snp.bottom).offset(19)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(65)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        requestContentTextView.snp.makeConstraints { make in
            make.top.equalTo(requestContentLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(requestContentTextView.snp.width).multipliedBy(1)
        }
    }
}
