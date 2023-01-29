//
//  WorksView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/29.
//

import UIKit

final class WorksView: SZView {
    // MARK: - Properties
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    let writeButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 31
        $0.backgroundColor = CustomColor.red
        $0.setImage(UIImage(named: "plus"), for: .normal)
    }
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            collectionView, writeButton
        )
    }
    override func setLayout() {
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(62)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(7)
            make.trailing.equalToSuperview().inset(11)
        }
    }
}
