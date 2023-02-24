//
//  WriteCategoryView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit
import SnapKit
import Then

final class WriteCategoryView: SZView {
    // MARK: - Properties
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
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
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
            make.top.equalTo(safeAreaLayoutGuide)
        }
    }
}
