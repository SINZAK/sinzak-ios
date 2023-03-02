//
//  SettingView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/02.
//

import UIKit
import SnapKit
import Then

final class SettingView: SZView {
    // MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    // MARK: - Design Helpers
    override func setView() {
       addSubview(collectionView)
    }
    override func setLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
