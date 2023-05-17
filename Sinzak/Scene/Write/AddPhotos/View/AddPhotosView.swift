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
    let nextButton = SZButton().then {
        $0.setTitle(I18NStrings.next, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.layer.cornerRadius = 33
        $0.backgroundColor = CustomColor.red
    }
    let currentPhotoCount = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.red50
        $0.text = "0"
    }
    private let maximumPhotoCount = UILabel().then {
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = " / 5"
    }
//    let thumbnailLabel = UILabel().then {
//        $0.font = .caption_B
//        $0.textColor = CustomColor.red50
//        $0.text = I18NStrings.thumbnail
//    }
//    let thumbnailMarkSquare = UIView().then {
//        $0.backgroundColor = .clear
//        $0.layer.cornerRadius = 12
//        $0.layer.borderColor = CustomColor.red50.cgColor
//        $0.layer.borderWidth = 2.0
//    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.alwaysBounceVertical = false
        $0.backgroundColor = .clear
        $0.register(
            AddPhotoCVC.self,
            forCellWithReuseIdentifier: AddPhotoCVC.identifier
        )
    }
    let uploadPhotoButton = UIButton().then {
        $0.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 4.0
        )
        $0.layer.cornerRadius = 24
        $0.setImage(
            UIImage(named: "camera")?.withTintColor(CustomColor.purple, renderingMode: .alwaysOriginal),
            for: .normal
        )
        
        $0.setTitle(I18NStrings.uploadPhotos, for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.layer.borderColor = CustomColor.purple.cgColor
        $0.layer.borderWidth = 1.0
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            currentPhotoCount,
            maximumPhotoCount,
            uploadPhotoButton,
//            thumbnailLabel,
//            thumbnailMarkSquare,
            collectionView,
            nextButton
        )
    }
    override func setLayout() {
        collectionView.collectionViewLayout = setLayout()
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(64)
            make.bottom.equalToSuperview().inset(24.0)
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
            make.top.equalTo(currentPhotoCount.snp.bottom)
            make.height.equalTo(132.0)
        }
        
        uploadPhotoButton.snp.makeConstraints { make in
            make.width.equalTo(192)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(24)
        }
    }
}

// 컴포지셔널 레이아웃
private extension AddPhotosView {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(105),
                heightDimension: .estimated(132.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets.bottom = 4.0
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(556.0),
                heightDimension: .estimated(132.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(7)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 16
            section.interGroupSpacing = 0
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}
