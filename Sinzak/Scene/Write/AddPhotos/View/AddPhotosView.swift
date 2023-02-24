//
//  AddPhotosView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class AddPhotosView: SZView {
    // MARK: - Properties
    let nextButton = UIButton().then {
        $0.setTitle(I18NStrings.next, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.layer.cornerRadius = 33
        $0.backgroundColor = CustomColor.red
    }
    let currentPhotoCount = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.red
        $0.text = "0"
    }
    private let maximumPhotoCount = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.black
        $0.text = " / 5"
    }
    let thumbnailLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.red50
        $0.text = I18NStrings.thumbnail
    }
    let thumbnailMarkSquare = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = CustomColor.red50!.cgColor
        $0.layer.borderWidth = 2.0
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    let uploadPhotoButton = UIButton().then {
        $0.layer.cornerRadius = 24
        $0.setImage(UIImage(named: "camera"), for: .normal)
        $0.setTitle(I18NStrings.uploadPhotos, for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.layer.borderColor = CustomColor.purple!.cgColor
        $0.layer.borderWidth = 1.0
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            currentPhotoCount,
            maximumPhotoCount,
            uploadPhotoButton,
            thumbnailLabel,
            thumbnailMarkSquare,
            collectionView,
            nextButton
        )
    }
    override func setLayout() {
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(65)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        maximumPhotoCount.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(8)
            make.top.equalTo(safeAreaLayoutGuide).inset(18)
        }
        currentPhotoCount.snp.makeConstraints { make in
            make.centerY.equalTo(maximumPhotoCount)
            make.trailing.equalTo(maximumPhotoCount.snp.leading)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(currentPhotoCount.snp.bottom).offset(25)
            make.height.equalTo(105)
        }
        thumbnailMarkSquare.snp.makeConstraints { make in
            make.width.height.equalTo(109)
            make.leading.equalToSuperview().inset(11.5)
            make.bottom.equalTo(collectionView).offset(4.5)
        }
        thumbnailLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailMarkSquare).offset(3)
            make.bottom.equalTo(thumbnailMarkSquare.snp.top).offset(-3)
        }
        uploadPhotoButton.snp.makeConstraints { make in
            make.width.equalTo(192)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(25)
        }
    }
}
